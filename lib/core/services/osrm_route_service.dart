import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';

class OSRMRouteService {
  final Dio _dio;

  OSRMRouteService(this._dio);

  Future<List<MapLatLng>> getRoute(MapLatLng origin, MapLatLng destination) async {
    try {
      final response = await _dio.get(
        'https://router.project-osrm.org/route/v1/driving/${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}',
        queryParameters: {
          'geometries': 'geojson',
          'overview': 'full',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['code'] == 'Ok' && (data['routes'] as List).isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'];
          final List coordinates = geometry['coordinates'];
          
          return coordinates.map((coord) {
            return MapLatLng(
              latitude: (coord[1] as num).toDouble(),
              longitude: (coord[0] as num).toDouble(),
            );
          }).toList();
        }
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('OSRMRouteService error: $e');
      }
      throw Exception('Failed to get route: $e');
    }
  }
}
