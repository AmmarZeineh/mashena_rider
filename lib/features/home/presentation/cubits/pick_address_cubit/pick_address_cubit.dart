import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/services/location_service.dart';
import 'package:mashena_rider/core/services/location_status.dart';
import 'package:mashena_rider/core/services/nominatim_service.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_location.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_request.dart';
import 'package:mashena_rider/features/home/domain/usecases/create_ride_request_usecase.dart';
import 'package:mashena_rider/features/home/presentation/models/confirmed_ride_flow_result.dart';
import 'pick_address_state.dart';

class PickAddressCubit extends Cubit<PickAddressState> {
  PickAddressCubit(
    this._locationService,
    this._placesService,
    this._createRideRequest,
  ) : super(PickAddressState.initial());

  final LocationService _locationService;
  final NominatimService _placesService;
  final CreateRideRequestUsecase _createRideRequest;
  Timer? _debounce;

  void initialize(ConfirmedRideFlowResult? initialData) {
    if (initialData == null) return;
    emit(
      state.copyWith(
        pickupPlace: initialData.pickupPlace,
        destinations: initialData.destinationPlaces,
        rideEstimateResponse: initialData.estimateResponse,
        selectedRideEstimate: initialData.estimateResponse.estimates.isEmpty
            ? null
            : initialData.estimateResponse.estimates.first,
      ),
    );
  }

  void setActiveField(int index) {
    emit(state.copyWith(activeFieldIndex: index, searchResults: []));
  }

  void addDestination() {
    final newDestinations = List<PlaceEntity?>.from(state.destinations)
      ..add(null);
    emit(
      state.copyWith(
        destinations: newDestinations,
        rideEstimateResponse: null,
        selectedRideEstimate: null,
      ),
    );
  }

  void removeDestination(int index) {
    if (state.destinations.length <= 1) return; // Must have at least one dest
    final newDestinations = List<PlaceEntity?>.from(state.destinations)
      ..removeAt(index);
    emit(
      state.copyWith(
        destinations: newDestinations,
        rideEstimateResponse: null,
        selectedRideEstimate: null,
      ),
    );
  }

  Future<void> useDeviceLocation({String? language}) async {
    emit(state.copyWith(isReversingGeocode: true));
    try {
      final status = await _locationService.requestPermissionIfNeeded();
      if (!status.serviceEnabled ||
          status.permission != LocationPermissionState.granted) {
        // Handle denied permission (UI could show a toast or dialog)
        if (kDebugMode) {
          print('Location permission denied or service disabled.');
        }
        emit(state.copyWith(isReversingGeocode: false));
        return;
      }

      final pos = await _locationService.getCurrentPosition();
      final pickupPlace = await _placesService.reverseGeocode(
        pos.latitude,
        pos.longitude,
        language: language,
      );

      emit(
        state.copyWith(
          pickupPlace: pickupPlace,
          isReversingGeocode: false,
          rideEstimateResponse: null,
          selectedRideEstimate: null,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('PickAddressCubit useDeviceLocation error: $e');
      }
      emit(state.copyWith(isReversingGeocode: false));
    }
  }

  void onSearchChanged(String query, {String? language}) {
    emit(
      state.copyWith(
        searchQuery: query,
        isSearching: true,
        rideEstimateResponse: null,
        selectedRideEstimate: null,
      ),
    );

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query, language: language);
    });
  }

  Future<void> _performSearch(String query, {String? language}) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(searchResults: [], isSearching: false));
      return;
    }

    try {
      final results = await _placesService.searchPlaces(
        query,
        language: language,
      );
      emit(state.copyWith(searchResults: results, isSearching: false));
    } catch (e) {
      if (kDebugMode) {
        print('PickAddressCubit _performSearch error: $e');
      }
      emit(state.copyWith(searchResults: [], isSearching: false));
    }
  }

  Future<void> selectPlace(PlaceEntity place, {int? index}) async {
    final targetIndex = index ?? state.activeFieldIndex;
    // Nominatim gives us full details upfront. No need for a second API call.
    if (targetIndex == 0) {
      emit(
        state.copyWith(
          pickupPlace: place,
          searchResults: [],
          rideEstimateResponse: null,
          selectedRideEstimate: null,
        ),
      );
    } else {
      final destIndex = targetIndex - 1;
      final newDestinations = List<PlaceEntity?>.from(state.destinations);
      if (destIndex >= 0 && destIndex < newDestinations.length) {
        newDestinations[destIndex] = place;
      }
      emit(
        state.copyWith(
          destinations: newDestinations,
          searchResults: [],
          rideEstimateResponse: null,
          selectedRideEstimate: null,
        ),
      );
    }
  }

  void selectRideEstimate(RideEstimate estimate) {
    emit(state.copyWith(selectedRideEstimate: estimate));
  }

  /// Called by the UI when the user presses the confirm button.
  /// All location fields must be filled before calling this.
  Future<void> confirmRide() async {
    if (!state.isReadyToConfirm) return;

    final pickup = RideLocation(
      lat: state.pickupPlace!.latitude,
      lng: state.pickupPlace!.longitude,
      address: state.pickupPlace!.address,
    );

    final List<PlaceEntity> allDests = state.destinations.cast<PlaceEntity>();
    final destinationPlace = allDests.last;
    final stopsPlaces = allDests.length > 1
        ? allDests.sublist(0, allDests.length - 1)
        : <PlaceEntity>[];

    final destination = RideLocation(
      lat: destinationPlace.latitude,
      lng: destinationPlace.longitude,
      address: destinationPlace.address,
    );

    final stops = stopsPlaces
        .map(
          (p) => RideLocation(
            lat: p.latitude,
            lng: p.longitude,
            address: p.address,
          ),
        )
        .toList();

    final request = RideRequest(
      pickup: pickup,
      destination: destination,
      stops: stops,
    );

    emit(
      state.copyWith(
        isCreatingRideRequest: true,
        rideEstimateResponse: null,
        selectedRideEstimate: null,
        errorMessage: null,
      ),
    );

    final result = await _createRideRequest(request);

    result.fold(
      (error) => emit(
        state.copyWith(isCreatingRideRequest: false, errorMessage: error),
      ),
      (estimateResponse) {
        emit(
          state.copyWith(
            isCreatingRideRequest: false,
            rideEstimateResponse: estimateResponse,
            selectedRideEstimate: estimateResponse.estimates.isEmpty
                ? null
                : estimateResponse.estimates.first,
          ),
        );
        if (kDebugMode) {
          print(
            'Ride Request Created. Estimates: ${estimateResponse.estimates}',
          );
        }
      },
    );
  }

  Future<void> confirmMapSelection(
    double lat,
    double lng, {
    String? language,
    int? index,
  }) async {
    emit(state.copyWith(isReversingGeocode: true));

    final place = await _placesService.reverseGeocode(
      lat,
      lng,
      language: language,
    );

    await selectPlace(place, index: index);
    emit(state.copyWith(isReversingGeocode: false));
  }
}
