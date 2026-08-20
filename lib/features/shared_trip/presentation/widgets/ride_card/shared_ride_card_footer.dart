import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_room_entity.dart';

class SharedRideCardFooter extends StatelessWidget {
  final SharedRideRoomEntity room;

  const SharedRideCardFooter({super.key, required this.room});

  String _formatFare(num fare) {
    try {
      final formatter = NumberFormat('#,###');
      return formatter.format(fare);
    } catch (_) {
      return fare.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Available Seats
          Row(
            children: [
              Icon(
                Icons.airline_seat_recline_normal_rounded,
                size: 18.r,
                color: room.availableSeats > 0
                    ? AppColors.shieldGreen
                    : AppColors.errorColor,
              ),
              SizedBox(width: 6.w),
              Text(
                s.sharedTripSeatsCount(room.availableSeats, room.maxPassengers),
                style: AppTextStyles.w600_14.copyWith(
                  color: room.availableSeats > 0
                      ? colorScheme.onSurface
                      : AppColors.errorColor,
                ),
              ),
            ],
          ),

          // Fare Per Seat
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _formatFare(room.farePerSeat),
                style: AppTextStyles.w700_18.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                s.currencySyp,
                style: AppTextStyles.w500_12.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                '/ ${s.sharedTripFarePerSeat}',
                style: AppTextStyles.w400_12.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
