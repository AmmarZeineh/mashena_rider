import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/controllers/app_map_controller.dart';
import '../../domain/entities/map_lat_lng.dart';

class GoogleMapControllerAdapter implements AppMapController {
  GoogleMapControllerAdapter(this._controller);

  final GoogleMapController _controller;

  @override
  Future<void> moveCamera(MapLatLng target, {double zoom = 14}) {
    return _controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(target.latitude, target.longitude),
        zoom,
      ),
    );
  }
}
