import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/trip_history/domain/entities/rider_trip_status.dart';

class TripStatusFilterBar extends StatelessWidget {
  final RiderTripStatus? selectedStatus;
  final ValueChanged<RiderTripStatus?> onStatusSelected;

  const TripStatusFilterBar({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final filters = <_FilterItem>[
      _FilterItem(status: null, label: s.commonAll),
      _FilterItem(status: RiderTripStatus.completed, label: s.statusCompleted),
      _FilterItem(status: RiderTripStatus.canceled, label: s.statusCancelled),
      _FilterItem(status: RiderTripStatus.started, label: s.statusInProgress),
    ];

    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: filters.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final item = filters[index];
          final isSelected = selectedStatus == item.status;

          return ChoiceChip(
            label: Text(
              item.label,
              style: isSelected
                  ? AppTextStyles.w600_14.copyWith(color: Colors.white)
                  : AppTextStyles.w500_14.copyWith(color: AppColors.textGrey),
            ),
            selected: isSelected,
            onSelected: (_) => onStatusSelected(item.status),
            selectedColor: AppColors.primaryColor,
            backgroundColor: Colors.white,
            elevation: isSelected ? 2 : 0,
            pressElevation: 1,
            side: BorderSide(
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.borderColor.withValues(alpha: 0.5),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}

class _FilterItem {
  final RiderTripStatus? status;
  final String label;

  const _FilterItem({required this.status, required this.label});
}
