import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate.dart';
import 'package:mashena_rider/features/home/presentation/booking/widgets/ride_tile.dart';

class RideList extends StatelessWidget {
  const RideList({
    super.key,
    required this.estimates,
    required this.selected,
    required this.onSelect,
    required this.emptyLabel,
  });

  final List<RideEstimate> estimates;
  final RideEstimate? selected;
  final ValueChanged<RideEstimate> onSelect;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (estimates.isEmpty) {
      final textTheme = Theme.of(context).textTheme;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: Text(
          emptyLabel,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textGrey,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: estimates.length,
      padding: EdgeInsets.only(bottom: 16.h),
      itemBuilder: (context, index) {
        final estimate = estimates[index];
        return RideTile(
          estimate: estimate,
          isSelected: _isSameEstimate(selected, estimate),
          onTap: () => onSelect(estimate),
        );
      },
    );
  }

  static bool _isSameEstimate(RideEstimate? selected, RideEstimate estimate) {
    if (selected == null) return false;

    if (selected.vehicleTypeId > 0 && estimate.vehicleTypeId > 0) {
      return selected.vehicleTypeId == estimate.vehicleTypeId;
    }

    return selected.name == estimate.name &&
        selected.estimatedFare == estimate.estimatedFare &&
        selected.currency == estimate.currency;
  }
}
