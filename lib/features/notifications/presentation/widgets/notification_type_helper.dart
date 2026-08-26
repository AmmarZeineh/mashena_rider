import 'package:flutter/material.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';

class NotificationTypeHelper {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const NotificationTypeHelper({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  factory NotificationTypeHelper.fromType(String type) {
    switch (type) {
      // 1. Trip Notifications
      case 'notification.trip.completed':
        return NotificationTypeHelper(
          icon: Icons.task_alt_rounded,
          iconColor: AppColors.shieldGreen,
          backgroundColor: AppColors.shieldGreen.withValues(alpha: 0.12),
        );

      case 'notification.trip.started':
        return NotificationTypeHelper(
          icon: Icons.directions_car_filled_rounded,
          iconColor: AppColors.primaryColor,
          backgroundColor: AppColors.primaryColor.withValues(alpha: 0.12),
        );

      case 'notification.trip.driver_arrived':
        return NotificationTypeHelper(
          icon: Icons.pin_drop_rounded,
          iconColor: const Color(0xFFF59E0B),
          backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.12),
        );

      case 'notification.trip.accepted':
        return NotificationTypeHelper(
          icon: Icons.check_circle_outline_rounded,
          iconColor: AppColors.primaryColor,
          backgroundColor: AppColors.primaryColor.withValues(alpha: 0.12),
        );

      case 'notification.trip.cancelled':
        return NotificationTypeHelper(
          icon: Icons.cancel_outlined,
          iconColor: AppColors.errorColor,
          backgroundColor: AppColors.errorColor.withValues(alpha: 0.12),
        );

      // 2. Shared Ride Notifications
      case 'notification.shared_ride.joined':
        return NotificationTypeHelper(
          icon: Icons.group_add_rounded,
          iconColor: AppColors.primaryColor,
          backgroundColor: AppColors.primaryColor.withValues(alpha: 0.12),
        );

      case 'notification.shared_ride.left':
        return NotificationTypeHelper(
          icon: Icons.group_remove_rounded,
          iconColor: const Color(0xFFF59E0B),
          backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.12),
        );

      case 'notification.shared_ride.removed':
        return NotificationTypeHelper(
          icon: Icons.group_off_rounded,
          iconColor: const Color(0xFFEA580C),
          backgroundColor: const Color(0xFFEA580C).withValues(alpha: 0.12),
        );

      // 3. Passenger Pool Notifications
      case 'notification.passenger_pool.member_joined':
        return NotificationTypeHelper(
          icon: Icons.person_add_alt_1_rounded,
          iconColor: AppColors.primaryColor,
          backgroundColor: AppColors.primaryColor.withValues(alpha: 0.12),
        );

      case 'notification.passenger_pool.member_left':
        return NotificationTypeHelper(
          icon: Icons.person_remove_rounded,
          iconColor: const Color(0xFFF59E0B),
          backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.12),
        );

      case 'notification.passenger_pool.driver_accepted':
        return NotificationTypeHelper(
          icon: Icons.drive_eta_rounded,
          iconColor: AppColors.shieldGreen,
          backgroundColor: AppColors.shieldGreen.withValues(alpha: 0.12),
        );

      case 'notification.passenger_pool.room_expired':
      case 'notification.passenger_pool.room_canceled':
        return NotificationTypeHelper(
          icon: Icons.timer_off_outlined,
          iconColor: AppColors.errorColor,
          backgroundColor: AppColors.errorColor.withValues(alpha: 0.12),
        );

      // 4. Wallet Notifications
      case 'notification.wallet.deposit':
        return NotificationTypeHelper(
          icon: Icons.account_balance_wallet_rounded,
          iconColor: AppColors.shieldGreen,
          backgroundColor: AppColors.shieldGreen.withValues(alpha: 0.12),
        );

      case 'notification.wallet.withdraw':
        return NotificationTypeHelper(
          icon: Icons.payments_outlined,
          iconColor: const Color(0xFFF59E0B),
          backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.12),
        );

      case 'notification.wallet.transfer':
        return NotificationTypeHelper(
          icon: Icons.swap_horiz_rounded,
          iconColor: const Color(0xFF8B5CF6),
          backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
        );

      // 5. Moderation & Penalties Notifications
      case 'notification.moderation.warning_issued':
        return NotificationTypeHelper(
          icon: Icons.warning_amber_rounded,
          iconColor: const Color(0xFFF59E0B),
          backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.12),
        );

      case 'notification.moderation.penalty_issued':
        return NotificationTypeHelper(
          icon: Icons.gavel_rounded,
          iconColor: AppColors.errorColor,
          backgroundColor: AppColors.errorColor.withValues(alpha: 0.12),
        );

      case 'notification.moderation.penalty_revoked':
      case 'notification.moderation.penalty_expired':
      case 'notification.moderation.appeal_approved':
        return NotificationTypeHelper(
          icon: Icons.check_circle_rounded,
          iconColor: AppColors.shieldGreen,
          backgroundColor: AppColors.shieldGreen.withValues(alpha: 0.12),
        );

      case 'notification.moderation.appeal_submitted':
        return NotificationTypeHelper(
          icon: Icons.mark_email_read_outlined,
          iconColor: AppColors.primaryColor,
          backgroundColor: AppColors.primaryColor.withValues(alpha: 0.12),
        );

      case 'notification.moderation.appeal_rejected':
        return NotificationTypeHelper(
          icon: Icons.highlight_off_rounded,
          iconColor: AppColors.errorColor,
          backgroundColor: AppColors.errorColor.withValues(alpha: 0.12),
        );

      // 6. Driver Approved
      case 'notification.driver.approved':
        return NotificationTypeHelper(
          icon: Icons.verified_user_rounded,
          iconColor: const Color(0xFF0D9488),
          backgroundColor: const Color(0xFF0D9488).withValues(alpha: 0.12),
        );

      // 7. General / Admin Notifications
      case 'ADMIN_NOTIFICATION':
      default:
        return NotificationTypeHelper(
          icon: Icons.notifications_active_outlined,
          iconColor: AppColors.primaryColor,
          backgroundColor: AppColors.primaryColor.withValues(alpha: 0.12),
        );
    }
  }
}
