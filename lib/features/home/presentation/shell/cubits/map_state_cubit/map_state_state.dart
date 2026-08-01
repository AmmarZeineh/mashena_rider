part of 'map_state_cubit.dart';

/// Holds the polylines and markers currently rendered on the map.
class MapStateState {
  const MapStateState({
    this.polylines = const [],
    this.markers = const [],
    this.isFetchingRoute = false,
  });

  final List<MapPolyline> polylines;
  final List<MapMarker> markers;
  final bool isFetchingRoute;

  MapStateState copyWith({
    List<MapPolyline>? polylines,
    List<MapMarker>? markers,
    bool? isFetchingRoute,
  }) {
    return MapStateState(
      polylines: polylines ?? this.polylines,
      markers: markers ?? this.markers,
      isFetchingRoute: isFetchingRoute ?? this.isFetchingRoute,
    );
  }
}
