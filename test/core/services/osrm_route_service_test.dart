import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/services/osrm_route_service.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late OSRMRouteService routeService;

  setUp(() {
    mockDio = MockDio();
    routeService = OSRMRouteService(mockDio);
  });

  group('OSRMRouteService', () {
    test(
      'should return null when points list has fewer than 2 coordinates',
      () async {
        final result = await routeService.getRouteDetails([
          const MapLatLng(latitude: 33.5138, longitude: 36.2765),
        ]);

        expect(result, isNull);
        verifyZeroInteractions(mockDio);
      },
    );

    test(
      'should parse geojson coordinates, distance, and duration on 200 Ok response',
      () async {
        final points = [
          const MapLatLng(latitude: 33.5138, longitude: 36.2765),
          const MapLatLng(latitude: 33.5200, longitude: 36.2800),
        ];

        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: {
              'code': 'Ok',
              'routes': [
                {
                  'distance': 1500.5,
                  'duration': 240.0,
                  'geometry': {
                    'coordinates': [
                      [36.2765, 33.5138],
                      [36.2800, 33.5200],
                    ],
                  },
                },
              ],
            },
          ),
        );

        final result = await routeService.getRouteDetails(points);

        expect(result, isNotNull);
        expect(result!.distance, 1500.5);
        expect(result.duration, 240.0);
        expect(result.points.length, 2);
        expect(result.points[0].latitude, 33.5138);
        expect(result.points[0].longitude, 36.2765);
        expect(result.points[1].latitude, 33.5200);
        expect(result.points[1].longitude, 36.2800);
      },
    );

    test(
      'should return null when OSRM returns non-Ok response code or empty routes',
      () async {
        final points = [
          const MapLatLng(latitude: 33.5138, longitude: 36.2765),
          const MapLatLng(latitude: 33.5200, longitude: 36.2800),
        ];

        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: {'code': 'NoRoute', 'routes': []},
          ),
        );

        final result = await routeService.getRouteDetails(points);

        expect(result, isNull);
      },
    );

    test(
      'should return null when Dio throws an exception (e.g. connection timeout)',
      () async {
        final points = [
          const MapLatLng(latitude: 33.5138, longitude: 36.2765),
          const MapLatLng(latitude: 33.5200, longitude: 36.2800),
        ];

        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        final result = await routeService.getRouteDetails(points);

        expect(result, isNull);
      },
    );
  });
}
