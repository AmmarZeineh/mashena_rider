import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import '../../domain/entities/active_trip_context.dart';

class ActiveTripCard extends StatelessWidget {
  final ActiveTripContext trip;
  final ValueChanged<ActiveTripContext> onTap;

  const ActiveTripCard({super.key, required this.trip, required this.onTap});

  String _formatStatus(BuildContext context, String status) {
    final s = S.of(context);
    final normalized = status.trim().toUpperCase();
    switch (normalized) {
      case 'STARTED':
        return s.activeTripsStatusStarted;
      case 'IN_PROGRESS':
        return s.activeTripsStatusInProgress;
      case 'DRIVER_ARRIVED':
        return s.activeTripsStatusDriverArrived;
      case 'OPEN':
        return s.activeTripsStatusOpen;
      case 'READY':
        return s.activeTripsStatusReady;
      case 'ACCEPTED':
        return s.activeTripsStatusAccepted;
      case 'PENDING':
        return s.activeTripsStatusPending;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    final cardBg = isDark
        ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.7)
        : Colors.white;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.25)
        : AppColors.borderColor.withValues(alpha: 0.5);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(trip),
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header: Trip Type + Tracking Role + Status Chip
                Row(
                  children: [
                    _buildTypeBadge(context),
                    SizedBox(width: 8.w),
                    _buildRoleBadge(context),
                    const Spacer(),
                    _buildStatusChip(context),
                  ],
                ),
                SizedBox(height: 16.h),

                // 2. Info Badges / Identifiers Row
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    if (trip.tripId != null)
                      _buildInfoTag(
                        icon: Icons.tag_rounded,
                        text: s.activeTripsTripId(trip.tripId!),
                        color: AppColors.primaryColor,
                      ),
                    if (trip.sharedRideId != null)
                      _buildInfoTag(
                        icon: Icons.meeting_room_outlined,
                        text: s.activeTripsSharedRideId(trip.sharedRideId!),
                        color: Colors.deepPurple,
                      ),
                    if (trip.rideRequestId != null)
                      _buildInfoTag(
                        icon: Icons.receipt_long_outlined,
                        text: s.activeTripsRideRequestId(trip.rideRequestId!),
                        color: Colors.blueGrey,
                      ),
                    if (trip.sharedRidePassengerId != null)
                      _buildInfoTag(
                        icon: Icons.badge_outlined,
                        text: s.activeTripsPassengerId(
                          trip.sharedRidePassengerId!,
                        ),
                        color: Colors.teal,
                      ),
                  ],
                ),

                // 3. Shared Ride Specific Metadata (Seats & Presence)
                if (trip.isSharedRide) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? colorScheme.surfaceContainerLow
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark
                            ? colorScheme.outlineVariant.withValues(alpha: 0.15)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.airline_seat_recline_normal_rounded,
                          size: 18.r,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          s.activeTripsActiveSeats(trip.activeSeats),
                          style: AppTextStyles.w600_12.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          trip.accountHolderOnBoard
                              ? Icons.verified_user_outlined
                              : Icons.supervisor_account_outlined,
                          size: 16.r,
                          color: trip.accountHolderOnBoard
                              ? AppColors.shieldGreen
                              : Colors.orange,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          trip.accountHolderOnBoard
                              ? s.activeTripsAccountHolderOnBoard
                              : s.activeTripsAccountHolderNotOnBoard,
                          style: AppTextStyles.w500_12.copyWith(
                            color: trip.accountHolderOnBoard
                                ? AppColors.shieldGreen
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 16.h),
                Divider(
                  height: 1,
                  thickness: 0.6,
                  color: isDark
                      ? colorScheme.outlineVariant.withValues(alpha: 0.2)
                      : Colors.grey.shade200,
                ),
                SizedBox(height: 12.h),

                // 4. Action Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      trip.isRegularTrip
                          ? s.activeTripsRegularTrip
                          : s.activeTripsSharedRide,
                      style: AppTextStyles.w600_14.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => onTap(trip),
                      icon: const Icon(Icons.navigation_rounded, size: 16),
                      label: Text(s.activeTripsLiveTracking),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(BuildContext context) {
    final s = S.of(context);
    final isRegular = trip.isRegularTrip;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isRegular
            ? AppColors.primaryColor.withValues(alpha: 0.12)
            : Colors.deepPurple.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRegular ? Icons.directions_car_rounded : Icons.groups_rounded,
            size: 14.r,
            color: isRegular ? AppColors.primaryColor : Colors.deepPurple,
          ),
          SizedBox(width: 4.w),
          Text(
            isRegular ? s.activeTripsRegularTrip : s.activeTripsSharedRide,
            style: AppTextStyles.w600_12.copyWith(
              color: isRegular ? AppColors.primaryColor : Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(BuildContext context) {
    final s = S.of(context);
    final isCompanion = trip.isCompanionBooking;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isCompanion
            ? Colors.orange.withValues(alpha: 0.12)
            : Colors.teal.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompanion ? Icons.person_add_alt_1_rounded : Icons.person_rounded,
            size: 13.r,
            color: isCompanion ? Colors.orange.shade800 : Colors.teal.shade700,
          ),
          SizedBox(width: 3.w),
          Text(
            isCompanion ? s.activeTripsCompanionBooking : s.activeTripsSelf,
            style: AppTextStyles.w600_10.copyWith(
              color: isCompanion
                  ? Colors.orange.shade800
                  : Colors.teal.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final formatted = _formatStatus(context, trip.status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.shieldGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7.r,
            height: 7.r,
            decoration: const BoxDecoration(
              color: AppColors.shieldGreen,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            formatted,
            style: AppTextStyles.w600_12.copyWith(color: AppColors.shieldGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTag({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.r, color: color),
          SizedBox(width: 4.w),
          Text(text, style: AppTextStyles.w500_11.copyWith(color: color)),
        ],
      ),
    );
  }
}
