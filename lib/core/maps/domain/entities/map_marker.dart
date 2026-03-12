import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';

class MapMarker {
  final String id;
  final MapLatLng position;
  final String iconPath; // For flutter_map image asset

  const MapMarker({
    required this.id, 
    required this.position,
    this.iconPath = 'assets/images/default_marker.png', // Temporary default
  });
}
