import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/maps/presentation/app_map.dart';
import 'flutter_map_controller_adapter.dart';

class FlutterMapWidget extends AppMap {
  const FlutterMapWidget({
    super.key,
    required super.initialPosition,
    required super.onMapCreated,
    super.onCameraMove,
    super.onCameraIdle,
    super.markers,
    super.polylines,
    super.showMyLocation,
  });

  @override
  State<FlutterMapWidget> createState() => _FlutterMapWidgetState();
}

class _FlutterMapWidgetState extends State<FlutterMapWidget> {
  late final MapController _mapController;
  
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: widget.initialPosition.toLatLng(),
        initialZoom: 15.0,
        onMapReady: () {
          widget.onMapCreated(FlutterMapControllerAdapter(_mapController));
        },
        onPositionChanged: (position, hasGesture) {
          if (widget.onCameraMove != null) {
            widget.onCameraMove!(
              MapLatLng(
                latitude: position.center.latitude,
                longitude: position.center.longitude,
              ),
            );
          }
        },
        // We simulate onCameraIdle by assuming the gesture ended or pos changed
        // Real idle detection might require a custom debounce or listening to map event stream.
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.mashena.rider',
        ),
        if (widget.polylines.isNotEmpty)
          PolylineLayer(
            polylines: widget.polylines.map((p) => Polyline(
              points: p.points.map((pt) => pt.toLatLng()).toList(),
              color: p.color,
              strokeWidth: p.width.toDouble(),
            )).toList(),
          ),
        if (widget.markers.isNotEmpty)
          MarkerLayer(
            markers: widget.markers.map((m) => Marker(
              point: m.position.toLatLng(),
              width: 80,
              height: 80,
              // We don't have exact anchor control mapped in AppMap, centering for now
              child: Image.asset(m.iconPath),
            )).toList(),
          ),
      ],
    );
  }
}
