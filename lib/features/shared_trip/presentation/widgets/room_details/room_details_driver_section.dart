import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_room_details_entity.dart';

class RoomDetailsDriverSection extends StatelessWidget {
  final SharedRideRoomDetailsEntity details;
  final bool? isDriverOnline;

  const RoomDetailsDriverSection({
    super.key,
    required this.details,
    this.isDriverOnline,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final driver = details.driver;
    final vehicle = details.vehicle;
    final isOnline = isDriverOnline ?? (driver?.isOnline ?? false);

    final cardBg = isDark ? colorScheme.surfaceContainerLow : Colors.white;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.3)
        : AppColors.borderColor.withValues(alpha: 0.5);
    final carIconBg = isDark
        ? colorScheme.surfaceContainerHighest
        : Colors.grey.shade100;
    final plateBg = isDark ? colorScheme.surfaceContainerHighest : Colors.white;
    final plateBorder = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.4)
        : AppColors.borderColor;

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
          // Header
          Row(
            children: [
              Icon(
                Icons.directions_car_filled_rounded,
                size: 18.r,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                '${s.sharedTripDriver} & ${s.sharedTripVehicle}',
                style: AppTextStyles.w600_16.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Driver Row
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: AppColors.primaryColor.withValues(
                      alpha: 0.15,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size: 24.r,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12.r,
                      height: 12.r,
                      decoration: BoxDecoration(
                        color: isOnline
                            ? AppColors.shieldGreen
                            : AppColors.textGrey.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? colorScheme.surface : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            driver != null && driver.fullName.isNotEmpty
                                ? driver.fullName
                                : 'Driver #${details.driverProfileId}',
                            style: AppTextStyles.w600_14.copyWith(
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (driver?.ratingAvg != null &&
                            driver!.ratingAvg! > 0) ...[
                          SizedBox(width: 6.w),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 14.r,
                                color: Colors.amber.shade700,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                driver.ratingAvg!.toStringAsFixed(1),
                                style: AppTextStyles.w600_12.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          s.sharedTripDriver,
                          style: AppTextStyles.w400_12.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                        if (driver?.city != null &&
                            driver!.city!.isNotEmpty) ...[
                          Text(
                            ' • ${driver.city}',
                            style: AppTextStyles.w400_12.copyWith(
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
          ),

          if (vehicle != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Divider(height: 1, thickness: 0.5, color: borderColor),
            ),

            // Vehicle Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: carIconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.directions_car_rounded,
                        size: 18.r,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              vehicle.model.isNotEmpty
                                  ? vehicle.model
                                  : vehicle.vehicleTypeName,
                              style: AppTextStyles.w600_14.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            if (vehicle.year != null) ...[
                              SizedBox(width: 4.w),
                              Text(
                                '(${vehicle.year})',
                                style: AppTextStyles.w400_12.copyWith(
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ],
                          ],
                        ),
                        Row(
                          children: [
                            if (vehicle.vehicleTypeName.isNotEmpty) ...[
                              Text(
                                vehicle.vehicleTypeName,
                                style: AppTextStyles.w500_12.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                            if (vehicle.color.isNotEmpty) ...[
                              Text(
                                ' • ${vehicle.color}',
                                style: AppTextStyles.w400_12.copyWith(
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                if (vehicle.plateNumber.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: plateBg,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: plateBorder, width: 1.2),
                      boxShadow: isDark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.pin_outlined,
                          size: 12.r,
                          color: AppColors.textGrey,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          vehicle.plateNumber,
                          style: AppTextStyles.w700_14.copyWith(
                            letterSpacing: 1.2,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
