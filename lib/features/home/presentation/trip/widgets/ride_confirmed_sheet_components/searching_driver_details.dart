import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';

class SearchingDriverDetails extends StatelessWidget {
  const SearchingDriverDetails({super.key});

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
                  S.of(context).rideLookingForDrivers,
                  style: AppTextStyles.w700_16.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                const AnimatedSearchingText(),
              ],
            ),
          ),
          // Pulsing search icon
          const PulsingRadarIcon(),
        ],
      ),
    );
  }
}

class PulsingRadarIcon extends StatefulWidget {
  const PulsingRadarIcon({super.key});

  @override
  State<PulsingRadarIcon> createState() => _PulsingRadarIconState();
}

class _PulsingRadarIconState extends State<PulsingRadarIcon>
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
          child: Opacity(opacity: 1.5 - _animation.value, child: child),
        );
      },
      child: Icon(Icons.radar_rounded, color: colorScheme.primary),
    );
  }
}

class AnimatedSearchingText extends StatefulWidget {
  const AnimatedSearchingText({super.key});
  @override
  State<AnimatedSearchingText> createState() => _AnimatedSearchingTextState();
}

class _AnimatedSearchingTextState extends State<AnimatedSearchingText>
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
        S.of(context).commonPleaseWait,
        style: AppTextStyles.w500_14.copyWith(color: AppColors.textGrey),
      ),
    );
  }
}
