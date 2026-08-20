import 'package:mashena_rider/core/services/logger_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';

class OSRMRouteDetails {
  final List<MapLatLng> points;
  final double distance; // meters
  final double duration; // seconds

  const OSRMRouteDetails({
    required this.points,
    required this.distance,
    required this.duration,
  });
}

class OSRMRouteService {
  final Dio _dio;

  OSRMRouteService(this._dio);

  Future<OSRMRouteDetails?> getRouteDetails(List<MapLatLng> points) async {
    if (points.length < 2) return null;
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
          final double distance = (route['distance'] as num).toDouble();
          final double duration = (route['duration'] as num).toDouble();

          final pts = coordinatesList.map((coord) {
            return MapLatLng(
              latitude: (coord[1] as num).toDouble(),
              longitude: (coord[0] as num).toDouble(),
            );
          }).toList();

          return OSRMRouteDetails(
            points: pts,
            distance: distance,
            duration: duration,
          );
        }
      }
      return null;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        LoggerService.debug(
          'OSRMRouteService.getRouteDetails error',
          name: 'core.services.osrm',
          error: e,
          stackTrace: stackTrace,
        );
      }
      return null;
    }
  }
}
