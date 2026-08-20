import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_room_details_entity.dart';

class RoomDetailsRouteSection extends StatelessWidget {
  final SharedRideRoomDetailsEntity details;

  const RoomDetailsRouteSection({super.key, required this.details});

  String _formatDepartureTime(DateTime dt) {
    try {
      final localDt = dt.toLocal();
      final timeFormatter = DateFormat('hh:mm a');
      final dateFormatter = DateFormat('EEE, MMM dd');
      return '${dateFormatter.format(localDt)} • ${timeFormatter.format(localDt)}';
    } catch (_) {
      return dt.toString();
    }
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).round();
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final remMin = minutes % 60;
    return '$hours h ${remMin > 0 ? '$remMin m' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final isCanceled = details.isCanceled;
    final statusColor = details.isOpen
        ? AppColors.shieldGreen
        : (isCanceled ? AppColors.errorColor : AppColors.textGrey);

    final cardBg = isDark ? colorScheme.surfaceContainerLow : Colors.white;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.3)
        : AppColors.borderColor.withValues(alpha: 0.5);
    final innerBoxBg = isDark
        ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.6)
        : Colors.grey.shade50;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Departure time & status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16.r,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    _formatDepartureTime(details.departureTime),
                    style: AppTextStyles.w600_14.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  details.isOpen ? s.sharedTripStatusOpen : details.status,
                  style: AppTextStyles.w600_12.copyWith(color: statusColor),
                ),
              ),
            ],
          ),

          // Cancellation Notice Banner
          if (isCanceled) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.errorColor.withValues(
                  alpha: isDark ? 0.15 : 0.08,
                ),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.errorColor.withValues(
                    alpha: isDark ? 0.4 : 0.3,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.cancel_outlined,
                    size: 16.r,
                    color: AppColors.errorColor,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      details.cancellationReason != null &&
                              details.cancellationReason!.isNotEmpty
                          ? 'Trip Canceled: ${details.cancellationReason}'
                          : 'Trip Canceled',
                      style: AppTextStyles.w600_12.copyWith(
                        color: AppColors.errorColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(height: 1, thickness: 0.5, color: borderColor),
          ),

          // Route: Origin -> Dest
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3.h),
                child: Icon(
                  Icons.trip_origin_rounded,
                  size: 16.r,
                  color: AppColors.shieldGreen,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.sharedTripPickup,
                      style: AppTextStyles.w400_12.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      details.originAddress.isNotEmpty
                          ? details.originAddress
                          : s.sharedTripPickup,
                      style: AppTextStyles.w600_14.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.only(left: 7.w),
            child: Container(
              width: 2.w,
              height: 24.h,
              color: colorScheme.outlineVariant.withValues(alpha: 0.6),
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3.h),
                child: Icon(
                  Icons.location_on_rounded,
                  size: 16.r,
                  color: AppColors.errorColor,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.sharedTripDestination,
                      style: AppTextStyles.w400_12.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      details.destAddress.isNotEmpty
                          ? details.destAddress
                          : s.sharedTripDestination,
                      style: AppTextStyles.w600_14.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Distance & duration row
          if (details.totalDistanceKm != null ||
              details.totalDurationSec != null) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: innerBoxBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (details.totalDistanceKm != null)
                    Row(
                      children: [
                        Icon(
                          Icons.route_rounded,
                          size: 16.r,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '${details.totalDistanceKm!.toStringAsFixed(1)} km',
                          style: AppTextStyles.w600_14.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  if (details.totalDistanceKm != null &&
                      details.totalDurationSec != null)
                    Container(width: 1.w, height: 16.h, color: borderColor),
                  if (details.totalDurationSec != null)
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 16.r,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          _formatDuration(details.totalDurationSec!),
                          style: AppTextStyles.w600_14.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
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
