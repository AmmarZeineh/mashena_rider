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

class _FlutterMapWidgetState extends State<FlutterMapWidget>
    with SingleTickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _markerAnimationController;
  final Map<String, MapLatLng> _previousMarkerPositions = {};
  final Map<String, MapLatLng> _targetMarkerPositions = {};

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _markerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    for (final m in widget.markers) {
      _previousMarkerPositions[m.id] = m.position;
      _targetMarkerPositions[m.id] = m.position;
    }
  }

  @override
  void didUpdateWidget(FlutterMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool anyPositionChanged = false;
    for (final m in widget.markers) {
      final oldPos = _targetMarkerPositions[m.id] ?? m.position;
      if (oldPos.latitude != m.position.latitude ||
          oldPos.longitude != m.position.longitude) {
        _previousMarkerPositions[m.id] = oldPos;
        _targetMarkerPositions[m.id] = m.position;
        anyPositionChanged = true;
      } else {
        _previousMarkerPositions[m.id] = m.position;
        _targetMarkerPositions[m.id] = m.position;
      }
    }
    if (anyPositionChanged) {
      _markerAnimationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _markerAnimationController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Widget _buildTileLayer(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Widget tileLayer = TileLayer(
      urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
      tileProvider: NetworkTileProvider(
        headers: {
          'User-Agent':
              'MashenaRiderApp/1.0 (com.mashena.rider; contact@mashena.com)',
        },
      ),
    );

    if (isDarkMode) {
      tileLayer = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.75,
          0.00,
          0.00,
          0,
          -15,
          0.00,
          0.78,
          0.00,
          0,
          -15,
          0.00,
          0.00,
          0.90,
          0,
          -8,
          0.00,
          0.00,
          0.00,
          1,
          0,
        ]),
        child: tileLayer,
      );
    }

    return tileLayer;
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
          widget.onCameraMove?.call(
            MapLatLng(
              latitude: position.center.latitude,
              longitude: position.center.longitude,
            ),
          );
        },
      ),
      children: [
        _buildTileLayer(context),

        if (widget.polylines.isNotEmpty)
          PolylineLayer(
            polylines: widget.polylines
                .map(
                  (p) => Polyline(
                    points: p.points.map((pt) => pt.toLatLng()).toList(),
                    color: p.color,
                    strokeWidth: p.width.toDouble(),
                  ),
                )
                .toList(),
          ),

        if (widget.markers.isNotEmpty)
          AnimatedBuilder(
            animation: _markerAnimationController,
            builder: (context, _) {
              return MarkerLayer(
                markers: widget.markers.map((m) {
                  final Widget child;

                  if (m.iconWidget != null) {
                    child = m.iconWidget!;
                  } else if (m.iconPath != null) {
                    child = Image.asset(m.iconPath!);
                  } else {
                    child = const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 36,
                    );
                  }

                  MapLatLng currentPos = m.position;
                  if (_markerAnimationController.isAnimating &&
                      _previousMarkerPositions.containsKey(m.id) &&
                      _targetMarkerPositions.containsKey(m.id)) {
                    final prev = _previousMarkerPositions[m.id]!;
                    final target = _targetMarkerPositions[m.id]!;
                    final t = _markerAnimationController.value;
                    currentPos = MapLatLng(
                      latitude: prev.latitude + (target.latitude - prev.latitude) * t,
                      longitude: prev.longitude + (target.longitude - prev.longitude) * t,
                    );
                  }

                  return Marker(
                    point: currentPos.toLatLng(),
                    width: 48,
                    height: 48,
                    child: child,
                  );
                }).toList(),
              );
            },
          ),
      ],
    );
  }
}
