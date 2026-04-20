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
}
