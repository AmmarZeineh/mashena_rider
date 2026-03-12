import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';

class NominatimService {
  final Dio _dio;

  /// Language code used for all Nominatim queries.
  /// Defaults to the device language. Call [setLanguage] to change.
  String _languageCode = WidgetsBinding.instance.platformDispatcher.locale.languageCode;

  NominatimService(this._dio);

  /// Updates the language code used for Nominatim API requests.
  void setLanguage(String languageCode) {
    _languageCode = languageCode;
  }

  Future<List<PlaceEntity>> searchPlaces(String query, {String? language}) async {
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'addressdetails': 1,
          'limit': 10,
          'countrycodes': 'sy',
          'accept-language': language ?? _languageCode,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final List data = response.data;
        return data.map((p) {
          return PlaceEntity(
            id:
                p['place_id']?.toString() ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            name: p['name'] ?? p['display_name']?.split(',').first ?? 'Unknown',
            address: p['display_name'] ?? '',
            latitude: double.tryParse(p['lat']?.toString() ?? '0') ?? 0.0,
            longitude: double.tryParse(p['lon']?.toString() ?? '0') ?? 0.0,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('NominatimService searchPlaces error: $e');
      }
      throw Exception('Failed to search places: $e');
    }
  }

  Future<PlaceEntity> reverseGeocode(double lat, double lng, {String? language}) async {
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'lat': lat,
          'lon': lng,
          'format': 'json',
          'accept-language': language ?? _languageCode,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['error'] == null) {
          final address = data['address'] as Map<String, dynamic>?;

          String name = data['name'] ?? '';
          if (name.isEmpty && address != null) {
            name =
                address['road'] ??
                address['neighbourhood'] ??
                address['suburb'] ??
                address['city_district'] ??
                data['display_name']?.split(',').first ??
                'Pinned Location';
          }

          return PlaceEntity(
            id:
                data['place_id']?.toString() ??
                'map_pick_${DateTime.now().millisecondsSinceEpoch}',
            name: name,
            address:
                data['display_name'] ??
                'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}',
            latitude: lat,
            longitude: lng,
          );
        }
      }

      return _fallbackPlace(lat, lng);
    } catch (e) {
      if (kDebugMode) {
        print('NominatimService reverseGeocode error: $e');
      }
      return _fallbackPlace(lat, lng);
    }
  }

  PlaceEntity _fallbackPlace(double lat, double lng) {
    return PlaceEntity(
      id: 'map_pick_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Pinned Location',
      address: 'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}',
      latitude: lat,
      longitude: lng,
    );
  }
}
