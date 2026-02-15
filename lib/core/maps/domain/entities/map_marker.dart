import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';

class MapMarker {
  final String id;
  final MapLatLng position;

  const MapMarker({required this.id, required this.position});
}
