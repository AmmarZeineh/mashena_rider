import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashena_rider/core/maps/infrastructure/google_maps/google_map_controller_adapter.dart';

import '../../presentation/app_map.dart';

class GoogleMapWidget extends AppMap {
  const GoogleMapWidget({
    super.key,
    required super.initialPosition,
    required super.onMapCreated,
    super.markers,
    super.polylines,
    super.showMyLocation,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: showMyLocation,
      myLocationButtonEnabled: showMyLocation,
      initialCameraPosition: CameraPosition(
        target: LatLng(initialPosition.latitude, initialPosition.longitude),
        zoom: 14,
      ),
      markers: markers
          .map(
            (m) => Marker(
              markerId: MarkerId(m.id),
              position: LatLng(m.position.latitude, m.position.longitude),
            ),
          )
          .toSet(),
      polylines: polylines
          .map(
            (p) => Polyline(
              polylineId: PolylineId(p.id),
              points: p.points
                  .map((e) => LatLng(e.latitude, e.longitude))
                  .toList(),
            ),
          )
          .toSet(),
      onMapCreated: (controller) {
        onMapCreated(GoogleMapControllerAdapter(controller));
      },
    );
  }
}
