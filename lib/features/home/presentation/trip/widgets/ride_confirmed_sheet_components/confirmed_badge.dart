import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/home_cubit/home_cubit.dart';

class ConfirmedBadge extends StatefulWidget {
  const ConfirmedBadge({super.key});

  @override
  State<ConfirmedBadge> createState() => _ConfirmedBadgeState();
}

class _ConfirmedBadgeState extends State<ConfirmedBadge>
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
    final homeState = context.watch<HomeCubit>().state;
    final isDriverArrived =
        homeState.isDriverArrived || homeState.isTripStarted;

    final badgeText = isDriverArrived
        ? S.of(context).rideDriverArrived
        : S.of(context).rideConfirmed;
    final badgeIcon = isDriverArrived
        ? Icons.location_on_rounded
        : Icons.check_circle_rounded;
    final badgeColor = Colors.green;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        ),
        child: Container(
          key: ValueKey<bool>(isDriverArrived),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(badgeIcon, color: badgeColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                badgeText,
                style: AppTextStyles.w700_14.copyWith(color: badgeColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
