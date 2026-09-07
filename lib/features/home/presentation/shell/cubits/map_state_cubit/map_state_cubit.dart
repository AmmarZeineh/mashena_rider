import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/base/base_cubit.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_marker.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_polyline.dart';

part 'map_state_state.dart';

/// The single source of truth for map overlays (polylines and markers).
///
/// Any cubit that needs to draw on the map writes to this cubit.
/// Widgets read from this cubit only — they never receive map data
/// directly from other cubits.
class MapStateCubit extends BaseCubit<MapStateState> {
  MapStateCubit() : super(const MapStateState());

  void setPolylines(List<MapPolyline> polylines) =>
      emit(state.copyWith(polylines: polylines));

  void setMarkers(List<MapMarker> markers) =>
      emit(state.copyWith(markers: markers));

  void setFetchingRoute({required bool isFetching}) =>
      emit(state.copyWith(isFetchingRoute: isFetching));

  /// Updates a single marker by id. Adds it if not present.
  void upsertMarker(MapMarker marker) {
    final updated = List<MapMarker>.from(state.markers)
      ..removeWhere((m) => m.id == marker.id)
      ..add(marker);
    emit(state.copyWith(markers: updated));
  }

  /// Removes a single marker by id.
  void removeMarker(String id) {
    emit(
      state.copyWith(markers: state.markers.where((m) => m.id != id).toList()),
    );
  }

  /// Clears all driver-related polylines from the map.
  void clearDriverPolylines() {
    final updated = state.polylines
        .where(
          (p) =>
              p.id != 'driver_to_pickup_border' &&
              p.id != 'driver_to_pickup' &&
              p.id != 'driver_to_destination_border' &&
              p.id != 'driver_to_destination',
        )
        .toList();
    emit(state.copyWith(polylines: updated));
  }

  /// Replaces all driver-related polylines in one atomic update.
  void updateDriverPolylines({
    required String borderId,
    required String lineId,
    required List<MapLatLng> points,
  }) {
    final updated = List<MapPolyline>.from(state.polylines)
      ..removeWhere(
        (p) =>
            p.id == 'driver_to_pickup_border' ||
            p.id == 'driver_to_pickup' ||
            p.id == 'driver_to_destination_border' ||
            p.id == 'driver_to_destination',
      )
      ..add(
        MapPolyline(
          id: borderId,
          points: points,
          color: const Color(0x4DFFC107), // amber 30%
          width: 10,
        ),
      )
      ..add(
        MapPolyline(
          id: lineId,
          points: points,
          color: const Color(0xFFFFC107), // amber
          width: 4,
        ),
      );
    emit(state.copyWith(polylines: updated));
  }

  /// Clears all map overlays (called on ride clear/cancel).
  void clearAll() => emit(const MapStateState());
}
