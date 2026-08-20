import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';

class CouponEmptyState extends StatelessWidget {
  final String emptyMessage;

  const CouponEmptyState({super.key, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: 64.r,
            color: AppColors.textGrey.withValues(alpha: 0.5),
          ),
          SizedBox(height: 12.h),
          Text(
            emptyMessage,
            style: AppTextStyles.w400_14.copyWith(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
