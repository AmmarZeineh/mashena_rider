import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';

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
