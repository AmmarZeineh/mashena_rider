import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/features/active_trips/data/models/active_trip_context_model.dart';
import 'package:mashena_rider/features/active_trips/domain/entities/active_trip_context.dart';

void main() {
  group('ActiveTripContextModel', () {
    test('should parse REGULAR_TRIP json payload correctly', () {
      final json = {
        "type": "REGULAR_TRIP",
        "trackingRole": "SELF",
        "tripId": 20,
        "rideRequestId": 109,
        "status": "started",
      };

      final model = ActiveTripContextModel.fromJson(json);

      expect(model.type, equals('REGULAR_TRIP'));
      expect(model.trackingRole, equals('SELF'));
      expect(model.tripId, equals(20));
      expect(model.rideRequestId, equals(109));
      expect(model.status, equals('started'));
      expect(model.sharedRideId, isNull);

      final entity = model.toEntity();
      expect(entity.type, equals(ActiveTripType.regularTrip));
      expect(entity.trackingRole, equals(ActiveTrackingRole.self));
      expect(entity.isRegularTrip, isTrue);
      expect(entity.isSharedRide, isFalse);
      expect(entity.isSelf, isTrue);
      expect(entity.isCompanionBooking, isFalse);
    });

    test('should parse SHARED_RIDE json payload correctly', () {
      final json = {
        "type": "SHARED_RIDE",
        "trackingRole": "COMPANION_BOOKING",
        "status": "IN_PROGRESS",
        "tripId": 300,
        "rideRequestId": 250,
        "sharedRideId": 100,
        "sharedRidePassengerId": 501,
        "accountHolderOnBoard": false,
        "activeSeats": 1,
      };

      final model = ActiveTripContextModel.fromJson(json);

      expect(model.type, equals('SHARED_RIDE'));
      expect(model.trackingRole, equals('COMPANION_BOOKING'));
      expect(model.tripId, equals(300));
      expect(model.rideRequestId, equals(250));
      expect(model.sharedRideId, equals(100));
      expect(model.sharedRidePassengerId, equals(501));
      expect(model.accountHolderOnBoard, isFalse);
      expect(model.activeSeats, equals(1));
      expect(model.status, equals('IN_PROGRESS'));

      final entity = model.toEntity();
      expect(entity.type, equals(ActiveTripType.sharedRide));
      expect(entity.trackingRole, equals(ActiveTrackingRole.companionBooking));
      expect(entity.isSharedRide, isTrue);
      expect(entity.isRegularTrip, isFalse);
      expect(entity.isCompanionBooking, isTrue);
      expect(entity.isSelf, isFalse);
      expect(entity.activeSeats, equals(1));
    });
  });
}
