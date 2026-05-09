import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';

class FoundDriverDetails extends StatelessWidget {
  const FoundDriverDetails({super.key});

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                    Text(
                      'Ahmad Ali',
                      style: AppTextStyles.w700_18.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '4.9',
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
                          '500+ Trips',
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
                      'Toyota Corolla • White',
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
                        color: Colors.amber.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: Text(
                        'ABC - 1234',
                        style: AppTextStyles.w700_12.copyWith(
                          color: Colors.amber.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  DriverActionCircle(
                    icon: Icons.chat_bubble_outline_rounded,
                    color: colorScheme.secondary,
                    onPressed: () {},
                  ),
                  SizedBox(width: 12.w),
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
