import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/network/token_manager.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/home/presentation/common/widgets/custom_drag_handle.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_lifecycle_cubit/trip_lifecycle_cubit.dart';

class DriverDetailsBottomSheet extends StatelessWidget {
  const DriverDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<TripLifecycleCubit, TripLifecycleState>(
      builder: (context, state) {
        final matchedTrip = state.matchedTrip;

        if (state.isLoadingMatchedTrip || matchedTrip == null) {
          return Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 48.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final driverName = matchedTrip.driverFullName;
        final rating = matchedTrip.driverRatingAvg.toStringAsFixed(1);
        final manufacturer = matchedTrip.manufacturer ?? '';
        final model = matchedTrip.model ?? S.of(context).rideVehicleDefault;
        final vehicleTitle = manufacturer.isNotEmpty
            ? '$manufacturer $model'
            : model;
        final vehicleColor = matchedTrip.color ?? '';
        final vehicleSubtitle = vehicleColor.isNotEmpty
            ? S
                  .of(context)
                  .rideVehicleColorAndType(
                    vehicleColor,
                    S.of(context).rideVehicleStandard,
                  )
            : S.of(context).rideVehicleStandard;
        final plateNumber = matchedTrip.plateNumber ?? '...';

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 12.h),
              const CustomDragHandle(),
              SizedBox(height: 16.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 48.r,
                      backgroundColor: colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      child: Icon(
                        Icons.person,
                        color: colorScheme.primary,
                        size: 48.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    GestureDetector(
                      onTap: () async {
                        final tokenManager = getIt.get<TokenManager>();
                        final token = await tokenManager.getAccessToken();
                        log(token.toString());
                      },
                      child: Text(
                        driverName,
                        style: AppTextStyles.w700_24.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatItem(
                          icon: Icons.star_rounded,
                          iconColor: AppColors.rating,
                          value: rating,
                          label: S.of(context).driverRating,
                        ),
                        SizedBox(width: 16.w),
                        Container(
                          width: 1.w,
                          height: 32.h,
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        _buildStatItem(
                          icon: Icons.check_circle_rounded,
                          iconColor: colorScheme.primary,
                          value: '500+',
                          label: S.of(context).driverTrips,
                        ),
                        SizedBox(width: 16.w),
                        Container(
                          width: 1.w,
                          height: 32.h,
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        _buildStatItem(
                          icon: Icons.access_time_rounded,
                          iconColor: colorScheme.secondary,
                          value: '3.5',
                          label: S.of(context).driverYears,
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),

                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        S.of(context).driverVehicleDetails,
                        style: AppTextStyles.w700_18.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildVehicleDetailItem(
                      context,
                      icon: Icons.directions_car_rounded,
                      title: vehicleTitle,
                      subtitle: vehicleSubtitle,
                    ),
                    SizedBox(height: 8.h),
                    _buildVehicleDetailItem(
                      context,
                      icon: Icons.pin_rounded,
                      title: S.of(context).driverLicensePlate,
                      subtitle: plateNumber,
                    ),

                    SizedBox(height: 32.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          S.of(context).commonClose,
                          style: AppTextStyles.w700_16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 24.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20.sp),
            SizedBox(width: 4.w),
            Text(value, style: AppTextStyles.w700_18),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.w500_14.copyWith(color: AppColors.textGrey),
        ),
      ],
    );
  }

  Widget _buildVehicleDetailItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colorScheme.primary, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.w600_16.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: AppTextStyles.w500_14.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
