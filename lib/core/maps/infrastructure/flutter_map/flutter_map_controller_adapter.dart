import 'package:flutter/widgets.dart';
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

  @override
  Future<void> fitBounds(List<MapLatLng> points, {double padding = 50}) async {
    if (points.isEmpty) return;

    if (points.length == 1) {
      _mapController.move(
        LatLng(points.first.latitude, points.first.longitude),
        15,
      );
      return;
    }

    final latLngs = points.map((p) => LatLng(p.latitude, p.longitude)).toList();
    final bounds = LatLngBounds.fromPoints(latLngs);

    final latDelta = (bounds.north - bounds.south).abs();
    final lngDelta = (bounds.east - bounds.west).abs();

    if (latDelta < 0.0001 && lngDelta < 0.0001) {
      _mapController.move(bounds.center, 15);
      return;
    }

    try {
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: EdgeInsets.all(padding),
          maxZoom: 17.0,
        ),
      );
    } catch (_) {
      _mapController.move(bounds.center, 15);
    }
  }
}
