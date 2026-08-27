import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:mashena_rider/core/base/base_cubit.dart';
import 'package:mashena_rider/core/services/location_service.dart';
import 'package:mashena_rider/core/services/location_status.dart';
import 'package:mashena_rider/core/services/logger_service.dart';
import 'package:mashena_rider/core/services/nominatim_service.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_location.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_request.dart';
import 'package:mashena_rider/features/home/domain/usecases/create_ride_request_usecase.dart';
import 'package:mashena_rider/features/home/presentation/common/models/confirmed_ride_flow_result.dart';
import 'package:mashena_rider/features/shared_trip/presentation/models/shared_trip_rooms_args.dart';
import 'pick_shared_trip_address_state.dart';

class PickSharedTripAddressCubit
    extends BaseCubit<PickSharedTripAddressState> {
  PickSharedTripAddressCubit(
    this._locationService,
    this._placesService,
    this._createRideRequest,
  ) : super(PickSharedTripAddressState.initial());

  final LocationService _locationService;
  final NominatimService _placesService;
  final CreateRideRequestUsecase _createRideRequest;
  Timer? _debounce;

  void initialize({
    ConfirmedRideFlowResult? initialData,
    SharedTripRoomsArgs? initialLocations,
  }) {
    if (initialLocations != null) {
      emit(
        state.copyWith(
          pickupPlace: () => initialLocations.pickup,
          destinationPlace: () => initialLocations.destination,
        ),
      );
      _validateDistances();
      return;
    }
    if (initialData == null) return;
    emit(
      state.copyWith(
        pickupPlace: () => initialData.pickupPlace,
        destinationPlace: () => initialData.destinationPlaces.isNotEmpty
            ? initialData.destinationPlaces.last
            : null,
        rideEstimateResponse: () => initialData.estimateResponse,
        selectedRideEstimate: () =>
            initialData.estimateResponse.estimates.isEmpty
            ? null
            : initialData.estimateResponse.estimates.first,
      ),
    );
    _validateDistances();
  }

  void setActiveField(int index) {
    emit(state.copyWith(activeFieldIndex: index, searchResults: const []));
  }

  void clearField(int index) {
    if (index == 0) {
      emit(
        state.copyWith(
          pickupPlace: () => null,
          searchQuery: '',
          searchResults: const [],
          rideEstimateResponse: () => null,
          selectedRideEstimate: () => null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          destinationPlace: () => null,
          searchQuery: '',
          searchResults: const [],
          rideEstimateResponse: () => null,
          selectedRideEstimate: () => null,
        ),
      );
    }
    _validateDistances();
  }

  Future<void> useDeviceLocation({String? language}) async {
    emit(state.copyWith(isReversingGeocode: true));
    try {
      final status = await _locationService.requestPermissionIfNeeded();
      if (!status.serviceEnabled ||
          status.permission != LocationPermissionState.granted) {
        if (kDebugMode) {
          LoggerService.debug(
            'Location permission denied or service disabled.',
            name: 'features.shared_trip.pick_address',
          );
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
          pickupPlace: () => pickupPlace,
          searchQuery: '',
          isReversingGeocode: false,
          rideEstimateResponse: () => null,
          selectedRideEstimate: () => null,
        ),
      );
      _validateDistances();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        LoggerService.debug(
          'PickSharedTripAddressCubit useDeviceLocation error',
          name: 'features.shared_trip.pick_address',
          error: e,
          stackTrace: stackTrace,
        );
      }
      emit(state.copyWith(isReversingGeocode: false));
    }
  }

  void onSearchChanged(String query, {String? language}) {
    emit(
      state.copyWith(
        searchQuery: query,
        isSearching: true,
        rideEstimateResponse: () => null,
        selectedRideEstimate: () => null,
      ),
    );

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query, language: language);
    });
  }

  Future<void> _performSearch(String query, {String? language}) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(searchResults: const [], isSearching: false));
      return;
    }

    try {
      final results = await _placesService.searchPlaces(
        query,
        language: language,
      );
      emit(state.copyWith(searchResults: results, isSearching: false));
    } catch (e, stackTrace) {
      if (kDebugMode) {
        LoggerService.debug(
          'PickSharedTripAddressCubit _performSearch error',
          name: 'features.shared_trip.pick_address',
          error: e,
          stackTrace: stackTrace,
        );
      }
      emit(state.copyWith(searchResults: const [], isSearching: false));
    }
  }

  Future<void> selectPlace(PlaceEntity place, {int? index}) async {
    final targetIndex = index ?? state.activeFieldIndex;
    if (targetIndex == 0) {
      emit(
        state.copyWith(
          pickupPlace: () => place,
          searchQuery: '',
          searchResults: const [],
          rideEstimateResponse: () => null,
          selectedRideEstimate: () => null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          destinationPlace: () => place,
          searchQuery: '',
          searchResults: const [],
          rideEstimateResponse: () => null,
          selectedRideEstimate: () => null,
        ),
      );
    }
    _validateDistances();
  }

  void _validateDistances() {
    final pickup = state.pickupPlace;
    final dest = state.destinationPlace;

    if (pickup == null || dest == null) {
      emit(state.copyWith(warningMessage: () => null));
      return;
    }

    const distanceTool = Distance();
    final meters = distanceTool.as(
      LengthUnit.Meter,
      LatLng(pickup.latitude, pickup.longitude),
      LatLng(dest.latitude, dest.longitude),
    );

    if (meters < 50) {
      emit(state.copyWith(warningMessage: () => 'error_stops_too_close'));
    } else {
      emit(state.copyWith(warningMessage: () => null));
    }
  }

  /// Confirms the pickup and destination for the shared trip.
  Future<void> confirmRide() async {
    if (!state.isReadyToConfirm) return;

    final pickup = RideLocation(
      lat: state.pickupPlace!.latitude,
      lng: state.pickupPlace!.longitude,
      address: state.pickupPlace!.address,
    );

    final destination = RideLocation(
      lat: state.destinationPlace!.latitude,
      lng: state.destinationPlace!.longitude,
      address: state.destinationPlace!.address,
    );

    final request = RideRequest(
      pickup: pickup,
      destination: destination,
      stops: const [],
    );

    emit(
      state.copyWith(
        isCreatingRideRequest: true,
        rideEstimateResponse: () => null,
        rideRequest: () => null,
        selectedRideEstimate: () => null,
        errorMessage: () => null,
      ),
    );

    final result = await _createRideRequest(request);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isCreatingRideRequest: false,
          errorMessage: () => failure,
        ),
      ),
      (estimateResponse) {
        emit(
          state.copyWith(
            isCreatingRideRequest: false,
            rideEstimateResponse: () => estimateResponse,
            rideRequest: () => request,
            selectedRideEstimate: () => estimateResponse.estimates.isEmpty
                ? null
                : estimateResponse.estimates.first,
          ),
        );
        if (kDebugMode) {
          LoggerService.debug(
            'Shared Trip Ride Request Created. Estimates: ${estimateResponse.estimates}',
            name: 'features.shared_trip.pick_address',
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

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
