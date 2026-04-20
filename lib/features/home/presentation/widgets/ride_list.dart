import 'package:flutter/material.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate.dart';
import 'package:mashena_rider/features/home/presentation/widgets/ride_tile.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Text(
          emptyLabel,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textGrey,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.45,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: estimates.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final estimate = estimates[index];
          return RideTile(
            estimate: estimate,
            isSelected: selected?.vehicleTypeId == estimate.vehicleTypeId,
            onTap: () => onSelect(estimate),
          );
        },
      ),
    );
  }
}
