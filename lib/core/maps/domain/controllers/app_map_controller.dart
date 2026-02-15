import '../entities/map_lat_lng.dart';

abstract class AppMapController {
  Future<void> moveCamera(MapLatLng target, {double zoom = 14});
}
