import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_room_entity.dart';

class SharedRideCardHeader extends StatelessWidget {
  final SharedRideRoomEntity room;

  const SharedRideCardHeader({super.key, required this.room});

  String _formatDepartureTime(DateTime dt) {
    try {
      final localDt = dt.toLocal();
      final timeFormatter = DateFormat('hh:mm a');
      final dateFormatter = DateFormat('MMM dd');
      return '${dateFormatter.format(localDt)} • ${timeFormatter.format(localDt)}';
    } catch (_) {
      return dt.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final isCanceled = room.isCanceled;
    final statusColor = room.isOpen
        ? AppColors.shieldGreen
        : (isCanceled ? AppColors.errorColor : AppColors.textGrey);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 16.r,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 6.w),
              Text(
                _formatDepartureTime(room.departureTime),
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
              room.isOpen ? s.sharedTripStatusOpen : room.status,
              style: AppTextStyles.w600_12.copyWith(color: statusColor),
            ),
          ),
        ],
      ),
    );
  }
}
