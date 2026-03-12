import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/services/location_service.dart';
import 'package:mashena_rider/core/services/location_status.dart';
import 'package:mashena_rider/core/services/nominatim_service.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';
import 'pick_address_state.dart';

class PickAddressCubit extends Cubit<PickAddressState> {
  PickAddressCubit(this._locationService, this._placesService)
    : super(PickAddressState.initial());

  final LocationService _locationService;
  final NominatimService _placesService;
  Timer? _debounce;

  void setActiveField(int index) {
    emit(state.copyWith(activeFieldIndex: index, searchResults: []));
  }

  void addDestination() {
    final newDestinations = List<PlaceEntity?>.from(state.destinations)
      ..add(null);
    emit(state.copyWith(destinations: newDestinations));
  }

  void removeDestination(int index) {
    if (state.destinations.length <= 1) return; // Must have at least one dest
    final newDestinations = List<PlaceEntity?>.from(state.destinations)
      ..removeAt(index);
    emit(state.copyWith(destinations: newDestinations));
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

      emit(state.copyWith(pickupPlace: pickupPlace, isReversingGeocode: false));
    } catch (e) {
      if (kDebugMode) {
        print('PickAddressCubit useDeviceLocation error: $e');
      }
      emit(state.copyWith(isReversingGeocode: false));
    }
  }

  void onSearchChanged(String query, {String? language}) {
    emit(state.copyWith(searchQuery: query, isSearching: true));

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
      final results = await _placesService.searchPlaces(query, language: language);
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
      emit(state.copyWith(pickupPlace: place, searchResults: []));
    } else {
      final destIndex = targetIndex - 1;
      final newDestinations = List<PlaceEntity?>.from(state.destinations);
      if (destIndex >= 0 && destIndex < newDestinations.length) {
        newDestinations[destIndex] = place;
      }
      emit(state.copyWith(destinations: newDestinations, searchResults: []));
    }
  }

  Future<void> confirmMapSelection(double lat, double lng, {String? language, int? index}) async {
    emit(state.copyWith(isReversingGeocode: true));

    final place = await _placesService.reverseGeocode(lat, lng, language: language);

    await selectPlace(place, index: index);
    emit(state.copyWith(isReversingGeocode: false));
  }
}
