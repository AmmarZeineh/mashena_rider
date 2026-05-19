import 'package:flutter/material.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/home/presentation/address/widgets/pick_location_circular_container.dart';

class PickLocationRow extends StatelessWidget {
  const PickLocationRow({super.key, this.address, required this.isActive});
  final String? address;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PickLocationCircularContainer(isActive: isActive),
        SizedBox(width: 16),
        Text(
          address ?? S.of(context).enterDestination,
          style: AppTextStyles.w400_12,
        ),
      ],
    );
  }
}
