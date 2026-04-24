import 'package:flutter/widgets.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';

/// A marker to display on the map.
///
/// Provide either [iconPath] for a simple asset image or [iconWidget]
/// for a fully custom widget (e.g. styled pins with glow effects).
class MapMarker {
  final String id;
  final MapLatLng position;
  final String? iconPath;
  final Widget? iconWidget;

  const MapMarker({
    required this.id,
    required this.position,
    this.iconPath,
    this.iconWidget,
  });
}
