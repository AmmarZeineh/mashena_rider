import '../entities/map_lat_lng.dart';

abstract class AppMapController {
  Future<void> moveCamera(MapLatLng target, {double zoom = 14});
  Future<void> fitBounds(List<MapLatLng> points, {double padding = 50});
}
