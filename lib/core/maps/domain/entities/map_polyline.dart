import 'package:flutter/material.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';

class MapPolyline {
  final String id;
  final List<MapLatLng> points;
  final Color color;
  final int width;

  const MapPolyline({
    required this.id, 
    required this.points,
    this.color = Colors.blue,
    this.width = 5,
  });
}
