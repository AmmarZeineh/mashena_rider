import 'package:flutter/widgets.dart';
import '../domain/controllers/app_map_controller.dart';
import '../domain/entities/map_lat_lng.dart';
import '../domain/entities/map_marker.dart';
import '../domain/entities/map_polyline.dart';

abstract class AppMap extends StatelessWidget {
  const AppMap({
    super.key,
    required this.initialPosition,
    required this.onMapCreated,
    this.markers = const [],
    this.polylines = const [],
    this.showMyLocation = false,
  });

  final MapLatLng initialPosition;
  final void Function(AppMapController controller) onMapCreated;
  final bool showMyLocation;

  final List<MapMarker> markers;
  final List<MapPolyline> polylines;
}
