import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/trip_history/domain/entities/trip_history_item.dart';

class TripHistoryCard extends StatelessWidget {
  final TripHistoryItem item;

  const TripHistoryCard({
    super.key,
    required this.item,
  });

  String _formatDateTime(String? rawIsoDate) {
    if (rawIsoDate == null || rawIsoDate.isEmpty) return '';
    try {
      final dt = DateTime.parse(rawIsoDate).toLocal();
      final monthNames = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final month = monthNames[dt.month - 1];
      final day = dt.day.toString().padLeft(2, '0');
      final hour = (dt.hour % 12 == 0 ? 12 : dt.hour % 12).toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$day $month ${dt.year} • $hour:$minute $period';
    } catch (_) {
      return rawIsoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isCompleted = item.isCompleted;
    final statusText = isCompleted
        ? s.statusCompleted
        : (item.isCancelled ? s.statusCancelled : s.statusInProgress);

    final statusColor = isCompleted
        ? AppColors.shieldGreen
        : (item.isCancelled ? AppColors.errorColor : AppColors.primaryColor);

    final formattedDate = _formatDateTime(item.createdAt);
    final driver = item.driver;
    final vehicle = item.vehicle;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Timestamp + Status Badge
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14.r,
                        color: AppColors.textGrey,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          formattedDate,
                          style: AppTextStyles.w500_12.copyWith(
                            color: AppColors.textGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Status Chip
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    statusText,
                    style: AppTextStyles.w600_12.copyWith(
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.borderColor),

          // Route Timeline (Pickup to Destination)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline Column (Dots + Connecting Line)
                Column(
                  children: [
                    SizedBox(height: 3.h),
                    Container(
                      width: 10.r,
                      height: 10.r,
                      decoration: const BoxDecoration(
                        color: AppColors.shieldGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2.w,
                      height: 32.h,
                      color: AppColors.borderColor,
                    ),
                    Icon(
                      Icons.location_on,
                      color: AppColors.primaryColor,
                      size: 16.r,
                    ),
                  ],
                ),
                SizedBox(width: 12.w),

                // Address Text Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pickup Address
                      Text(
                        item.pickupAddress,
                        style: AppTextStyles.w600_14.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 20.h),
                      // Destination Address
                      Text(
                        item.destAddress,
                        style: AppTextStyles.w600_14.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                // Fare Display
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${item.finalFare}',
                      style: AppTextStyles.w700_18.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Text(
                      s.appCurrency,
                      style: AppTextStyles.w500_12.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Footer Row: Driver, Vehicle, Distance & Duration Info
          if (driver != null || item.distanceKm != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.lightScaffold,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Driver Info
                  if (driver != null)
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14.r,
                            backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.person,
                              size: 16.r,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driver.fullName ?? '',
                                  style: AppTextStyles.w600_12.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (vehicle != null && vehicle.model != null)
                                  Text(
                                    '${vehicle.model} • ${vehicle.color ?? ''}',
                                    style: AppTextStyles.w400_12.copyWith(
                                      color: AppColors.textGrey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Distance / Duration Chips
                  Row(
                    children: [
                      if (item.distanceKm != null) ...[
                        Icon(
                          Icons.route_outlined,
                          size: 14.r,
                          color: AppColors.textGrey,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${item.distanceKm} km',
                          style: AppTextStyles.w500_12.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                      if (item.durationSec != null && item.durationSec! > 0) ...[
                        SizedBox(width: 10.w),
                        Icon(
                          Icons.access_time_rounded,
                          size: 14.r,
                          color: AppColors.textGrey,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${(item.durationSec! / 60).round()} min',
                          style: AppTextStyles.w500_12.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
