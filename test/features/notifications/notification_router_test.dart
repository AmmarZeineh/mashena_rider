import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/features/notifications/presentation/widgets/notification_type_helper.dart';

void main() {
  group('NotificationTypeHelper Tests', () {
    test('correctly maps trip notification types', () {
      final completed = NotificationTypeHelper.fromType('notification.trip.completed');
      expect(completed.icon, isNotNull);

      final started = NotificationTypeHelper.fromType('notification.trip.started');
      expect(started.icon, isNotNull);

      final arrived = NotificationTypeHelper.fromType('notification.trip.driver_arrived');
      expect(arrived.icon, isNotNull);

      final accepted = NotificationTypeHelper.fromType('notification.trip.accepted');
      expect(accepted.icon, isNotNull);

      final cancelled = NotificationTypeHelper.fromType('notification.trip.cancelled');
      expect(cancelled.icon, isNotNull);
    });

    test('correctly maps shared ride and pool notification types', () {
      final poolJoined = NotificationTypeHelper.fromType('notification.passenger_pool.member_joined');
      expect(poolJoined.icon, isNotNull);

      final poolLeft = NotificationTypeHelper.fromType('notification.passenger_pool.member_left');
      expect(poolLeft.icon, isNotNull);

      final poolDriver = NotificationTypeHelper.fromType('notification.passenger_pool.driver_accepted');
      expect(poolDriver.icon, isNotNull);

      final sharedJoined = NotificationTypeHelper.fromType('notification.shared_ride.joined');
      expect(sharedJoined.icon, isNotNull);
    });

    test('correctly maps moderation notification types', () {
      final warning = NotificationTypeHelper.fromType('notification.moderation.warning_issued');
      expect(warning.icon, isNotNull);

      final penalty = NotificationTypeHelper.fromType('notification.moderation.penalty_issued');
      expect(penalty.icon, isNotNull);

      final revoked = NotificationTypeHelper.fromType('notification.moderation.penalty_revoked');
      expect(revoked.icon, isNotNull);

      final appealApproved = NotificationTypeHelper.fromType('notification.moderation.appeal_approved');
      expect(appealApproved.icon, isNotNull);
    });

    test('correctly maps wallet notification types', () {
      final deposit = NotificationTypeHelper.fromType('notification.wallet.deposit');
      expect(deposit.icon, isNotNull);

      final withdraw = NotificationTypeHelper.fromType('notification.wallet.withdraw');
      expect(withdraw.icon, isNotNull);

      final transfer = NotificationTypeHelper.fromType('notification.wallet.transfer');
      expect(transfer.icon, isNotNull);
    });
  });
}
