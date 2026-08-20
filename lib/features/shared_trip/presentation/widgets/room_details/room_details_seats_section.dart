import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_room_details_entity.dart';

class RoomDetailsSeatsSection extends StatelessWidget {
  final SharedRideRoomDetailsEntity details;
  final Set<int> onlineUserIds;

  const RoomDetailsSeatsSection({
    super.key,
    required this.details,
    this.onlineUserIds = const {},
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark ? colorScheme.surfaceContainerLow : Colors.white;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.3)
        : AppColors.borderColor.withValues(alpha: 0.5);
    final itemBg = isDark
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
          // Section Title & summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.event_seat_rounded,
                    size: 18.r,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    s.sharedTripOccupancy,
                    style: AppTextStyles.w600_16.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: details.availableSeats > 0
                      ? AppColors.shieldGreen.withValues(alpha: 0.12)
                      : AppColors.errorColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  s.sharedTripSeatsCount(
                    details.availableSeats,
                    details.maxPassengers,
                  ),
                  style: AppTextStyles.w600_12.copyWith(
                    color: details.availableSeats > 0
                        ? AppColors.shieldGreen
                        : AppColors.errorColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Visual Seat Grid
          Row(
            children: List.generate(details.maxPassengers, (index) {
              final isOccupied = index < details.occupiedSeats;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isOccupied
                        ? AppColors.primaryColor.withValues(
                            alpha: isDark ? 0.15 : 0.08,
                          )
                        : AppColors.shieldGreen.withValues(
                            alpha: isDark ? 0.15 : 0.08,
                          ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isOccupied
                          ? AppColors.primaryColor.withValues(alpha: 0.35)
                          : AppColors.shieldGreen.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isOccupied
                            ? Icons.person_rounded
                            : Icons.airline_seat_recline_normal_rounded,
                        size: 24.r,
                        color: isOccupied
                            ? AppColors.primaryColor
                            : AppColors.shieldGreen,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        isOccupied ? 'Occupied' : 'Seat ${index + 1}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: isOccupied
                              ? AppColors.primaryColor
                              : AppColors.shieldGreen,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          // Passenger list chips if available
          if (details.passengers.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Text(
              s.sharedTripPassengers,
              style: AppTextStyles.w500_12.copyWith(color: AppColors.textGrey),
            ),
            SizedBox(height: 8.h),
            Column(
              children: details.passengers.map((passenger) {
                final isPaid = passenger.paymentStatus.toUpperCase() == 'PAID';
                final isOnline = onlineUserIds.contains(
                  passenger.riderProfileId,
                );

                Color statusColor;
                String statusLabel = passenger.status;
                if (passenger.status == 'ON_BOARD') {
                  statusColor = AppColors.primaryColor;
                  statusLabel = 'On Board';
                } else if (passenger.status == 'DROPPED_OFF') {
                  statusColor = AppColors.shieldGreen;
                  statusLabel = 'Dropped Off';
                } else {
                  statusColor = Colors.orange;
                  statusLabel = 'Joined';
                }

                final displayName = passenger.riderName?.isNotEmpty == true
                    ? passenger.riderName!
                    : 'Rider #${passenger.riderProfileId}';

                return Container(
                  margin: EdgeInsets.only(bottom: 6.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: itemBg,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 14.r,
                                backgroundColor: AppColors.primaryColor
                                    .withValues(alpha: 0.15),
                                child: Icon(
                                  Icons.person_outline_rounded,
                                  size: 16.r,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              if (isOnline)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 8.r,
                                    height: 8.r,
                                    decoration: BoxDecoration(
                                      color: AppColors.shieldGreen,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? colorScheme.surface
                                            : Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            displayName,
                            style: AppTextStyles.w500_12.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              '${passenger.seatsNeeded} ${passenger.seatsNeeded == 1 ? 'seat' : 'seats'}',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              statusLabel,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: isPaid
                                  ? AppColors.shieldGreen.withValues(
                                      alpha: 0.12,
                                    )
                                  : Colors.orange.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              passenger.paymentStatus,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: isPaid
                                    ? AppColors.shieldGreen
                                    : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
