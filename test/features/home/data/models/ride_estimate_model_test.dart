import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/features/home/data/mappers/ride_estimate_mapper.dart';
import 'package:mashena_rider/features/home/data/mappers/ride_estimate_response_mapper.dart';
import 'package:mashena_rider/features/home/data/models/ride_estimate_model.dart';
import 'package:mashena_rider/features/home/data/models/ride_estimate_response_model.dart';

void main() {
  group('RideEstimateModel & AppliedCouponModel', () {
    test('parses estimate with discount and applied coupon correctly', () {
      final json = {
        'vehicleTypeId': 1,
        'name': 'Economy',
        'imageUrl': {'url': 'https://example.com/car.png'},
        'currency': 'SYP',
        'estimatedFare': 20000,
        'originalFare': 25000,
        'discountAmount': 5000,
        'finalFare': 20000,
        'appliedCoupon': {
          'id': 42,
          'code': 'SAVE5000',
          'type': 'FIXED',
          'value': 5000,
          'remainingUsages': 2,
          'expiresAt': '2026-08-27T18:42:18.655Z',
        },
      };

      final model = RideEstimateModel.fromJson(json);

      expect(model.vehicleTypeId, equals(1));
      expect(model.name, equals('Economy'));
      expect(model.imageUrl, equals('https://example.com/car.png'));
      expect(model.currency, equals('SYP'));
      expect(model.estimatedFare, equals(20000.0));
      expect(model.originalFare, equals(25000.0));
      expect(model.discountAmount, equals(5000.0));
      expect(model.finalFare, equals(20000.0));
      expect(model.appliedCoupon, isNotNull);
      expect(model.appliedCoupon!.id, equals(42));
      expect(model.appliedCoupon!.code, equals('SAVE5000'));
      expect(model.appliedCoupon!.type, equals('FIXED'));
      expect(model.appliedCoupon!.value, equals(5000.0));
      expect(model.appliedCoupon!.remainingUsages, equals(2));
      expect(
        model.appliedCoupon!.expiresAt,
        equals(DateTime.parse('2026-08-27T18:42:18.655Z')),
      );

      final entity = model.toEntity();
      expect(entity.hasDiscount, isTrue);
      expect(entity.displayOriginalFare, equals(25000.0));
      expect(entity.displayFinalFare, equals(20000.0));
      expect(entity.effectiveDiscountAmount, equals(5000.0));
      expect(entity.appliedCoupon?.code, equals('SAVE5000'));
    });

    test(
      'handles empty imageUrl map and missing discount fields gracefully',
      () {
        final json = {
          'vehicleTypeId': 2,
          'name': 'VIP',
          'imageUrl': {},
          'currency': 'SYP',
          'estimatedFare': 35000,
        };

        final model = RideEstimateModel.fromJson(json);

        expect(model.vehicleTypeId, equals(2));
        expect(model.name, equals('VIP'));
        expect(model.imageUrl, isNull);
        expect(model.currency, equals('SYP'));
        expect(model.estimatedFare, equals(35000.0));
        expect(model.originalFare, isNull);
        expect(model.discountAmount, isNull);
        expect(model.finalFare, isNull);
        expect(model.appliedCoupon, isNull);

        final entity = model.toEntity();
        expect(entity.hasDiscount, isFalse);
        expect(entity.displayOriginalFare, equals(35000.0));
        expect(entity.displayFinalFare, equals(35000.0));
        expect(entity.effectiveDiscountAmount, equals(0.0));
        expect(entity.appliedCoupon, isNull);
      },
    );

    test('parses full RideEstimateResponse payload from user prompt', () {
      final fullResponseJson = {
        'pickup': {'lat': 33.5138, 'lng': 36.2765, 'address': 'Damascus'},
        'destination': {'lat': 33.5200, 'lng': 36.2800, 'address': 'Mazza'},
        'stops': [
          {'lat': 33.5150, 'lng': 36.2780, 'address': 'Stop 1'},
        ],
        'distanceKm': 5.2,
        'durationMin': 12.0,
        'stopsCount': 1,
        'isNight': true,
        'estimates': [
          {
            'vehicleTypeId': 1,
            'name': 'Standard',
            'imageUrl': {},
            'currency': 'SYP',
            'estimatedFare': 18000,
            'originalFare': 20000,
            'discountAmount': 2000,
            'finalFare': 18000,
            'appliedCoupon': {
              'id': 1,
              'code': 'NIGHT2K',
              'type': 'FIXED',
              'value': 2000,
              'remainingUsages': 1,
              'expiresAt': '2026-08-27T18:42:18.655Z',
            },
          },
        ],
        'routeGeometry': {
          'distanceMeters': 5200,
          'durationSeconds': 720,
          'points': [
            {'lat': 33.5138, 'lng': 36.2765},
            {'lat': 33.5200, 'lng': 36.2800},
          ],
        },
      };

      final responseModel = RideEstimateResponseModel.fromJson(
        fullResponseJson,
      );
      expect(responseModel.distanceKm, equals(5.2));
      expect(responseModel.durationMin, equals(12.0));
      expect(responseModel.stopsCount, equals(1));
      expect(responseModel.isNight, isTrue);
      expect(responseModel.estimates.length, equals(1));

      final estimate = responseModel.estimates.first;
      expect(estimate.vehicleTypeId, equals(1));
      expect(estimate.name, equals('Standard'));
      expect(estimate.originalFare, equals(20000.0));
      expect(estimate.discountAmount, equals(2000.0));
      expect(estimate.finalFare, equals(18000.0));
      expect(estimate.appliedCoupon?.code, equals('NIGHT2K'));

      final entityResponse = responseModel.toEntity();
      final entityEstimate = entityResponse.estimates.first;
      expect(entityEstimate.hasDiscount, isTrue);
      expect(entityEstimate.displayOriginalFare, equals(20000.0));
      expect(entityEstimate.displayFinalFare, equals(18000.0));
      expect(entityEstimate.appliedCoupon?.code, equals('NIGHT2K'));
    });
  });
}
