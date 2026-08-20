import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';

class NotificationsEmptyState extends StatelessWidget {
  final VoidCallback onRefresh;

  const NotificationsEmptyState({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: AppColors.primaryColor,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 120.h),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_off_outlined,
                      size: 64.r,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    s.noNotifications,
                    style: AppTextStyles.w700_18.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    s.notificationsEmptySubtitle,
                    style: AppTextStyles.w400_14.copyWith(
                      color: AppColors.textGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
