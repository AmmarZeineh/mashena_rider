import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/maps/domain/controllers/app_map_controller.dart';

class FlutterMapControllerAdapter implements AppMapController {
  final MapController _mapController;

  FlutterMapControllerAdapter(this._mapController);

  @override
  Future<void> moveCamera(MapLatLng target, {double zoom = 14}) async {
    _mapController.move(LatLng(target.latitude, target.longitude), zoom);
  }
}
