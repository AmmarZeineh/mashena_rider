import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';
import 'package:mashena_rider/features/home/presentation/cubits/home_location_cubit/home_location_cubit.dart';
import 'package:mashena_rider/features/home/presentation/models/confirmed_ride_flow_result.dart';
import 'package:mashena_rider/features/home/presentation/widgets/custom_drag_handle.dart';

class RideConfirmedBottomSheet extends StatelessWidget {
  const RideConfirmedBottomSheet({
    super.key,
    required this.rideResult,
    required this.submissionResponse,
  });

  final ConfirmedRideFlowResult rideResult;
  final RideSubmissionResponse submissionResponse;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
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

            // Confirmed Status Badge
            Center(child: _ConfirmedBadge()),

            SizedBox(height: 24.h),

            // Simulated Driver Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _DriverCard(),
            ),

            SizedBox(height: 24.h),

            // Trip Details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _TripDetails(submissionResponse: submissionResponse),
            ),

            SizedBox(height: 32.h),

            // Cancel Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
              ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16.h),
              child: _CancelButton(
                onPressed: () {
                  context.read<HomeCubit>().clearRideFlow();
                },
                label: 'Cancel Ride',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmedBadge extends StatefulWidget {
  @override
  State<_ConfirmedBadge> createState() => _ConfirmedBadgeState();
}

class _ConfirmedBadgeState extends State<_ConfirmedBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Ride Confirmed',
              style: AppTextStyles.w700_14.copyWith(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          // Simulated Avatar
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, color: colorScheme.primary),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Finding your driver...',
                  style: AppTextStyles.w700_16.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                _AnimatedSearchingText(),
              ],
            ),
          ),
          // Pulsing search icon
          const _PulsingRadarIcon(),
        ],
      ),
    );
  }
}

class _PulsingRadarIcon extends StatefulWidget {
  const _PulsingRadarIcon();

  @override
  State<_PulsingRadarIcon> createState() => _PulsingRadarIconState();
}

class _PulsingRadarIconState extends State<_PulsingRadarIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Opacity(
            opacity: 1.5 - _animation.value,
            child: child,
          ),
        );
      },
      child: Icon(
        Icons.radar_rounded,
        color: colorScheme.primary,
      ),
    );
  }
}

class _AnimatedSearchingText extends StatefulWidget {
  @override
  State<_AnimatedSearchingText> createState() => _AnimatedSearchingTextState();
}

class _AnimatedSearchingTextState extends State<_AnimatedSearchingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Text(
        'Please wait',
        style: AppTextStyles.w500_14.copyWith(color: AppColors.textGrey),
      ),
    );
  }
}

class _TripDetails extends StatelessWidget {
  const _TripDetails({required this.submissionResponse});

  final RideSubmissionResponse submissionResponse;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _DetailItem(
          icon: Icons.attach_money_rounded,
          value:
              '${submissionResponse.currency} ${_formatNum(submissionResponse.estimatedFare)}',
          label: 'Est. Fare',
          color: Colors.green,
        ),
        Container(width: 1, height: 30.h, color: colorScheme.outlineVariant),
        _DetailItem(
          icon: Icons.speed_rounded,
          value: '${_formatNum(submissionResponse.distanceKm)} km',
          label: 'Distance',
          color: colorScheme.primary,
        ),
        Container(width: 1, height: 30.h, color: colorScheme.outlineVariant),
        _DetailItem(
          icon: Icons.access_time_rounded,
          value: '${_formatNum(submissionResponse.durationMin)} min',
          label: 'Duration',
          color: colorScheme.secondary,
        ),
      ],
    );
  }

  static String _formatNum(double value) => value.truncateToDouble() == value
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTextStyles.w700_16.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.w500_12.copyWith(color: AppColors.textGrey),
        ),
      ],
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.onPressed, required this.label});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Text(label, style: AppTextStyles.w700_16),
    );
  }
}
