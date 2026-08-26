import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import '../../domain/entities/pool_room_entity.dart';

class PoolSuggestionCard extends StatelessWidget {
  final PoolRoomEntity room;
  final VoidCallback onJoin;

  const PoolSuggestionCard({
    super.key,
    required this.room,
    required this.onJoin,
  });

  String _formatTime(DateTime? time) {
    if (time == null) return 'Departing soon';
    final format = DateFormat('h:mm a');
    return 'Departs at ${format.format(time.toLocal())}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? Theme.of(context).colorScheme.surfaceContainerHigh
        : Colors.white;
    final borderColor = isDark ? Colors.white12 : AppColors.borderColor;

    final availableSeats = room.availableSeats;
    final hostMember = room.members
        .where((m) => m.riderProfileId == room.creatorRiderProfileId)
        .firstOrNull;
    final hostName = hostMember?.riderName ?? 'Host Rider';

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      color: AppColors.primaryColor,
                      size: 14.r,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      _formatTime(room.departureTime),
                      style: AppTextStyles.w600_12.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: availableSeats > 0
                      ? AppColors.shieldGreen.withValues(alpha: 0.12)
                      : Colors.grey.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '$availableSeats/${room.maxPassengers} seats open',
                  style: AppTextStyles.w600_12.copyWith(
                    color: availableSeats > 0
                        ? AppColors.shieldGreen
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Route Locations
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 10.r,
                    height: 10.r,
                    decoration: const BoxDecoration(
                      color: AppColors.shieldGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 24.h,
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                  ),
                  Container(
                    width: 10.r,
                    height: 10.r,
                    decoration: const BoxDecoration(
                      color: AppColors.errorColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.meetingAddress != null &&
                              room.meetingAddress!.isNotEmpty
                          ? room.meetingAddress!
                          : 'Shared Meeting Point',
                      style: AppTextStyles.w500_14.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      room.destinationAddress != null &&
                              room.destinationAddress!.isNotEmpty
                          ? room.destinationAddress!
                          : 'Destination',
                      style: AppTextStyles.w500_14.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          const Divider(height: 1),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14.r,
                    backgroundColor: const Color(0xFFFFB300),
                    child: Text(
                      hostName.isNotEmpty ? hostName[0].toUpperCase() : 'H',
                      style: AppTextStyles.w700_12.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Hosted by $hostName',
                    style: AppTextStyles.w500_12.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              FilledButton(
                onPressed: availableSeats > 0 ? onJoin : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                ),
                child: Text(
                  'Join Pool',
                  style: AppTextStyles.w600_14.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
