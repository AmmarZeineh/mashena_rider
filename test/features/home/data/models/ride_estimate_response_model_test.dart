import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/features/home/data/models/ride_estimate_response_model.dart';

void main() {
  test('maps ride estimate response to entity', () {
    final model = RideEstimateResponseModel.fromJson({
      'rideRequestId': 42,
      'distanceKm': 12.5,
      'durationMin': '18',
      'stopsCount': 1,
      'estimates': [
        {
          'vehicleTypeId': '7',
          'name': 'Comfort',
          'imageUrl': {'url': 'https://example.com/car.png'},
          'currency': 'SYP',
          'estimatedFare': '12500.5',
        },
      ],
    });

    final entity = model.toEntity();

    expect(entity.rideRequestId, 42);
    expect(entity.distanceKm, 12.5);
    expect(entity.durationMin, 18);
    expect(entity.stopsCount, 1);
    expect(entity.estimates, hasLength(1));
    expect(entity.estimates.first.vehicleTypeId, 7);
    expect(entity.estimates.first.name, 'Comfort');
    expect(entity.estimates.first.imageUrl, 'https://example.com/car.png');
    expect(entity.estimates.first.currency, 'SYP');
    expect(entity.estimates.first.estimatedFare, 12500.5);
    expect(entity.routePoints, isEmpty);
  });

  test('keeps empty imageUrl objects nullable', () {
    final model = RideEstimateResponseModel.fromJson({
      'rideRequestId': 0,
      'distanceKm': 0,
      'durationMin': 0,
      'stopsCount': 0,
      'estimates': [
        {
          'vehicleTypeId': 0,
          'name': 'Economy',
          'imageUrl': <String, dynamic>{},
          'currency': 'SYP',
          'estimatedFare': 0,
        },
      ],
    });

    expect(model.toEntity().estimates.first.imageUrl, isNull);
  });

  test('parses routeGeometry points into routePoints', () {
    final model = RideEstimateResponseModel.fromJson({
      'distanceKm': 7.134,
      'durationMin': 10,
      'stopsCount': 1,
      'isNight': false,
      'estimates': [],
      'routeGeometry': {
        'distanceMeters': 7134,
        'durationSeconds': 611.3,
        'points': [
          {'lat': 33.513844, 'lng': 36.276511},
          {'lat': 33.513973, 'lng': 36.275756},
          {'lat': 33.514234, 'lng': 36.274507},
        ],
      },
    });

    final entity = model.toEntity();

    expect(entity.routePoints, hasLength(3));
    expect(entity.routePoints[0].latitude, closeTo(33.513844, 0.000001));
    expect(entity.routePoints[0].longitude, closeTo(36.276511, 0.000001));
    expect(entity.routePoints[1].latitude, closeTo(33.513973, 0.000001));
    expect(entity.routePoints[2].latitude, closeTo(33.514234, 0.000001));
  });

  test('routePoints is empty when routeGeometry is absent', () {
    final model = RideEstimateResponseModel.fromJson({
      'distanceKm': 5.0,
      'durationMin': 8,
      'stopsCount': 0,
      'isNight': false,
      'estimates': [],
    });

    expect(model.toEntity().routePoints, isEmpty);
  });
}

