import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';

class MapPolyline {
  final String id;
  final List<MapLatLng> points;

  const MapPolyline({required this.id, required this.points});
}
