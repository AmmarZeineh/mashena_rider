import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';

class OSRMRouteService {
  final Dio _dio;

  OSRMRouteService(this._dio);

  Future<List<MapLatLng>> getRoute(List<MapLatLng> points) async {
    if (points.length < 2) return [];
    try {
      final coordinates = points
          .map((p) => '${p.longitude},${p.latitude}')
          .join(';');
      final response = await _dio.get(
        'https://router.project-osrm.org/route/v1/driving/$coordinates',
        queryParameters: {'geometries': 'geojson', 'overview': 'full'},
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['code'] == 'Ok' && (data['routes'] as List).isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'];
          final List coordinatesList = geometry['coordinates'];

          return coordinatesList.map((coord) {
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
      // Return empty list instead of throwing to allow best-effort marker display
      return [];
    }
  }
}
