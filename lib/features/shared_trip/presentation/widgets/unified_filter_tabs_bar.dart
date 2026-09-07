import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import '../cubits/shared_trip_rooms_cubit/shared_trip_rooms_state.dart';

class UnifiedFilterTabsBar extends StatelessWidget {
  final UnifiedRideFilter activeFilter;
  final ValueChanged<UnifiedRideFilter> onFilterSelected;
  final int allCount;
  final int driverRidesCount;
  final int poolLobbiesCount;

  const UnifiedFilterTabsBar({
    super.key,
    required this.activeFilter,
    required this.onFilterSelected,
    required this.allCount,
    required this.driverRidesCount,
    required this.poolLobbiesCount,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          _FilterTabChip(
            title: s.unifiedTripAll,
            icon: Icons.all_inclusive_rounded,
            count: allCount,
            isSelected: activeFilter == UnifiedRideFilter.all,
            onTap: () => onFilterSelected(UnifiedRideFilter.all),
          ),
          SizedBox(width: 8.w),
          _FilterTabChip(
            title: s.unifiedTripDriverRides,
            icon: Icons.directions_car_rounded,
            count: driverRidesCount,
            isSelected: activeFilter == UnifiedRideFilter.driverRides,
            onTap: () => onFilterSelected(UnifiedRideFilter.driverRides),
          ),
          SizedBox(width: 8.w),
          _FilterTabChip(
            title: s.unifiedTripPoolLobbies,
            icon: Icons.groups_3_rounded,
            count: poolLobbiesCount,
            isSelected: activeFilter == UnifiedRideFilter.poolLobbies,
            onTap: () => onFilterSelected(UnifiedRideFilter.poolLobbies),
          ),
        ],
      ),
    );
  }
}

class _FilterTabChip extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTabChip({
    required this.title,
    required this.icon,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final selectedBg = isDark
        ? AppColors.primaryColor.withValues(alpha: 0.25)
        : AppColors.primaryColor.withValues(alpha: 0.12);
    final unselectedBg = isDark
        ? colorScheme.surfaceContainerHigh
        : Colors.grey.shade100;

    final selectedBorder = AppColors.primaryColor;
    final unselectedBorder = isDark ? Colors.white12 : Colors.grey.shade300;

    final textColor = isSelected
        ? AppColors.primaryColor
        : colorScheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$title, $count',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? selectedBg : unselectedBg,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? selectedBorder : unselectedBorder,
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16.r, color: textColor),
                SizedBox(width: 6.w),
                Text(
                  title,
                  style: AppTextStyles.w600_12.copyWith(
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : colorScheme.outlineVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    count.toString(),
                    style: AppTextStyles.w600_10.copyWith(
                      color: isSelected ? Colors.white : colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
