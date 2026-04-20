import 'package:flutter/material.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate.dart';

class BookRideButton extends StatelessWidget {
  const BookRideButton({
    super.key,
    required this.selected,
    required this.label,
  });

  final RideEstimate? selected;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: SizedBox(
        height: 56,
        child: FilledButton(
          onPressed: selected == null
              ? null
              : () => Navigator.of(context).pop(selected),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            disabledBackgroundColor: AppColors.primaryColor.withAlpha(80),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Text(
            label,
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
