import 'dart:async';
import 'dart:math' show max;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/driver_tracking_cubit/driver_tracking_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_lifecycle_cubit/trip_lifecycle_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_share_cubit/trip_share_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/widgets/trip_share_bottom_sheet.dart';

import 'driver_details_bottom_sheet.dart';

class FoundDriverDetails extends StatelessWidget {
  const FoundDriverDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tripLifecycleState = context.watch<TripLifecycleCubit>().state;
    final driverTrackingState = context.watch<DriverTrackingCubit>().state;

    final matchedTrip = tripLifecycleState.matchedTrip;

    if (tripLifecycleState.isLoadingMatchedTrip || matchedTrip == null) {
      return Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                S.of(context).rideLoadingDriverDetails,
                style: AppTextStyles.w600_14.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final driverName = matchedTrip.driverFullName;
    final rating = matchedTrip.driverRatingAvg.toStringAsFixed(1);
    final vehicleModel = matchedTrip.model ?? 'Vehicle';
    final vehicleColor = matchedTrip.color ?? '';
    final vehicleText = vehicleColor.isNotEmpty
        ? S.of(context).rideVehicleModelAndColor(vehicleModel, vehicleColor)
        : vehicleModel;
    final plateNumber = matchedTrip.plateNumber ?? '...';
    final eta = driverTrackingState.driverEta;
    final distance = driverTrackingState.driverDistance;
    final isDriverArrived =
        tripLifecycleState.isDriverArrived || tripLifecycleState.isTripStarted;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (tripLifecycleState.isDriverArrived &&
              !tripLifecycleState.isTripStarted) ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: colorScheme.tertiary, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: colorScheme.onTertiaryContainer,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          S.of(context).rideDriverArrivedAtPickup,
                          style: AppTextStyles.w700_14.copyWith(
                            color: colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  _FreeWaitTimerWidget(
                    freeWaitTimeSeconds: tripLifecycleState.freeWaitTimeSeconds,
                    arrivedAt: tripLifecycleState.arrivedAt,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    S.of(context).rideWaitingChargesWarning,
                    style: AppTextStyles.w500_12.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
          ] else if (isDriverArrived) ...[
            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: AppColors.success,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    tripLifecycleState.isTripStarted
                        ? S.of(context).rideInProgressHeadingToDestination
                        : S.of(context).rideDriverArrived,
                    style: AppTextStyles.w700_14.copyWith(color: AppColors.success),
                  ),
                ),
              ],
            ),
            Divider(
              height: 24.h,
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ] else if (eta != null || distance != null) ...[
            Row(
              children: [
                Icon(
                  Icons.directions_car_rounded,
                  color: colorScheme.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '${S.of(context).rideDriverOnWay} • $eta ($distance)',
                    style: AppTextStyles.w700_14.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              height: 24.h,
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ],
          Row(
            children: [
              // Driver Avatar
              CircleAvatar(
                radius: 26.r,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                child: Icon(
                  Icons.person,
                  color: colorScheme.primary,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          driverName,
                          style: AppTextStyles.w700_18.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Material(
                          color: Colors.transparent,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    const DriverDetailsBottomSheet(),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(4.w),
                              child: Icon(
                                Icons.info_outline_rounded,
                                color: colorScheme.primary,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: AppColors.rating,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          rating,
                          style: AppTextStyles.w500_14.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          width: 4.w,
                          height: 4.w,
                          decoration: const BoxDecoration(
                            color: AppColors.textGrey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '500+ ${S.of(context).driverTrips}',
                          style: AppTextStyles.w500_14.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Car Details and Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicleText,
                      style: AppTextStyles.w600_14.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: colorScheme.tertiary),
                      ),
                      child: Text(
                        plateNumber,
                        style: AppTextStyles.w700_12.copyWith(
                          color: colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  DriverActionCircle(
                    icon: Icons.share_rounded,
                    color: colorScheme.tertiary,
                    onPressed: () {
                      final rideRequestId = matchedTrip.rideRequestId;
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => BlocProvider<TripShareCubit>(
                          create: (_) => getIt<TripShareCubit>(),
                          child: TripShareBottomSheet(
                            rideRequestId: rideRequestId,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 8.w),
                  DriverActionCircle(
                    icon: Icons.chat_bubble_outline_rounded,
                    color: colorScheme.secondary,
                    onPressed: () {},
                  ),
                  SizedBox(width: 8.w),
                  DriverActionCircle(
                    icon: Icons.phone_rounded,
                    color: colorScheme.primary,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DriverActionCircle extends StatelessWidget {
  const DriverActionCircle({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Icon(icon, color: color, size: 24.sp),
        ),
      ),
    );
  }
}

class _FreeWaitTimerWidget extends StatefulWidget {
  const _FreeWaitTimerWidget({
    required this.freeWaitTimeSeconds,
    this.arrivedAt,
  });

  final int freeWaitTimeSeconds;
  final String? arrivedAt;

  @override
  State<_FreeWaitTimerWidget> createState() => _FreeWaitTimerWidgetState();
}

class _FreeWaitTimerWidgetState extends State<_FreeWaitTimerWidget> {
  Timer? _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _calculateRemaining();
        });
      }
    });
  }

  void _calculateRemaining() {
    if (widget.arrivedAt != null) {
      final arrivedTime =
          DateTime.tryParse(widget.arrivedAt!)?.toLocal() ?? DateTime.now();
      final elapsed = DateTime.now().difference(arrivedTime).inSeconds;
      _remainingSeconds = max(0, widget.freeWaitTimeSeconds - elapsed);
    } else {
      _remainingSeconds = max(0, widget.freeWaitTimeSeconds);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remainingSeconds <= 0) {
      return Text(
        S.of(context).rideWaitingChargesApplying,
        style: AppTextStyles.w700_14.copyWith(color: Theme.of(context).colorScheme.error),
      );
    }

    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return Text(
      S.of(context).rideFreeWaitingTime(minutes, seconds),
      style: AppTextStyles.w700_14.copyWith(color: Theme.of(context).colorScheme.onTertiaryContainer),
    );
  }
}
