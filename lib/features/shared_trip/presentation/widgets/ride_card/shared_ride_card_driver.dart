import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_driver_entity.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_vehicle_entity.dart';

class SharedRideCardDriver extends StatelessWidget {
  final SharedRideDriverEntity? driver;
  final SharedRideVehicleEntity? vehicle;

  const SharedRideCardDriver({super.key, this.driver, this.vehicle});

  @override
  Widget build(BuildContext context) {
    if (driver == null && vehicle == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final stripBg = isDark
        ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.6)
        : Colors.grey.shade50;
    final plateBg = isDark ? colorScheme.surfaceContainerHighest : Colors.white;
    final plateBorder = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.4)
        : AppColors.borderColor.withValues(alpha: 0.6);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      color: stripBg,
      child: Row(
        children: [
          // Driver Info & Rating
          if (driver != null && driver!.fullName.isNotEmpty) ...[
            CircleAvatar(
              radius: 14.r,
              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.15),
              child: Icon(
                Icons.person_rounded,
                size: 16.r,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      driver!.fullName,
                      style: AppTextStyles.w600_14.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (driver!.ratingAvg != null && driver!.ratingAvg! > 0) ...[
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
                          driver!.ratingAvg!.toStringAsFixed(1),
                          style: AppTextStyles.w600_12.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Vehicle Info
          if (vehicle != null) ...[
            SizedBox(width: 8.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.directions_car_rounded,
                  size: 15.r,
                  color: AppColors.textGrey,
                ),
                SizedBox(width: 4.w),
                Text(
                  vehicle!.model.isNotEmpty
                      ? vehicle!.model
                      : vehicle!.vehicleTypeName,
                  style: AppTextStyles.w500_12.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
                if (vehicle!.plateNumber.isNotEmpty) ...[
                  SizedBox(width: 6.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: plateBg,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: plateBorder),
                    ),
                    child: Text(
                      vehicle!.plateNumber,
                      style: AppTextStyles.w600_12.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
