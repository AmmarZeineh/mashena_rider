import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_room_entity.dart';

class SharedRideCardRoute extends StatelessWidget {
  final SharedRideRoomEntity room;

  const SharedRideCardRoute({super.key, required this.room});

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).round();
    if (minutes < 60) {
      return '~$minutes min';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return remainingMinutes > 0
        ? '${hours}h ${remainingMinutes}m'
        : '${hours}h';
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final searchDetails = room.searchDetails;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          // Origin Point
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3.h),
                child: Icon(
                  Icons.trip_origin_rounded,
                  size: 14.r,
                  color: AppColors.shieldGreen,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.originAddress.isNotEmpty
                          ? room.originAddress
                          : s.sharedTripPickup,
                      style: AppTextStyles.w500_14.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (searchDetails != null &&
                        searchDetails.originDistanceKm > 0)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          s.sharedTripOriginDistance(
                            searchDetails.originDistanceKm.toStringAsFixed(2),
                          ),
                          style: AppTextStyles.w400_12.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Connecting Line & Trip Stats Badge (Distance / Duration)
          Row(
            children: [
              SizedBox(width: 6.w),
              Container(
                width: 2.w,
                height: 20.h,
                color: colorScheme.outlineVariant.withValues(alpha: 0.6),
              ),
              if (room.totalDistanceKm != null &&
                  room.totalDistanceKm! > 0) ...[
                SizedBox(width: 12.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.4,
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.straighten_rounded,
                        size: 12.r,
                        color: AppColors.textGrey,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${room.totalDistanceKm!.toStringAsFixed(1)} km',
                        style: AppTextStyles.w500_12.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                      if (room.totalDurationSec != null &&
                          room.totalDurationSec! > 0) ...[
                        Text(
                          ' • ${_formatDuration(room.totalDurationSec!)}',
                          style: AppTextStyles.w500_12.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),

          // Destination Point
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3.h),
                child: Icon(
                  Icons.location_on_rounded,
                  size: 14.r,
                  color: AppColors.errorColor,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.destAddress.isNotEmpty
                          ? room.destAddress
                          : s.sharedTripDestination,
                      style: AppTextStyles.w500_14.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (searchDetails != null &&
                        searchDetails.destinationDistanceKm > 0)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          s.sharedTripDestDistance(
                            searchDetails.destinationDistanceKm.toStringAsFixed(
                              2,
                            ),
                          ),
                          style: AppTextStyles.w400_12.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
