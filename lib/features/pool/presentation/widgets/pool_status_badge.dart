import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import '../../domain/entities/pool_room_status.dart';

class PoolStatusBadge extends StatefulWidget {
  final PoolRoomStatus status;
  final int currentPassengers;
  final int maxPassengers;

  const PoolStatusBadge({
    super.key,
    required this.status,
    required this.currentPassengers,
    required this.maxPassengers,
  });

  @override
  State<PoolStatusBadge> createState() => _PoolStatusBadgeState();
}

class _PoolStatusBadgeState extends State<PoolStatusBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.05).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReady = widget.status.isReadyForDriver;
    final isMatched = widget.status.isMatched;

    final badgeColor = isMatched
        ? AppColors.shieldGreen
        : isReady
        ? const Color(0xFFE65100) // Deep Orange
        : AppColors.primaryColor;

    final title = isMatched
        ? 'Driver Assigned!'
        : isReady
        ? 'Finding Driver...'
        : 'Looking for Passengers';

    final subtitle = isMatched
        ? 'Switching to active ride tracking'
        : isReady
        ? 'Room is full (${widget.currentPassengers}/${widget.maxPassengers}) • Drivers notified'
        : '${widget.currentPassengers}/${widget.maxPassengers} passengers joined';

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: badgeColor.withValues(alpha: 0.35),
                blurRadius: 14 * _pulseAnimation.value,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: isReady
                    ? SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Icon(
                        isMatched
                            ? Icons.check_circle_outline_rounded
                            : Icons.groups_2_rounded,
                        color: Colors.white,
                        size: 20.r,
                      ),
              ),
              SizedBox(width: 12.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.w700_16.copyWith(
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.w400_12.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
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
}
