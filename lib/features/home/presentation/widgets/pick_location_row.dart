import 'package:flutter/material.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/home/presentation/widgets/pick_location_circular_container.dart';

class PickLocationRow extends StatelessWidget {
  const PickLocationRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PickLocationCircularContainer(isActive: true),
        SizedBox(width: 16),
        Text('Neemuch RD. Gopalbari, Bari Sad', style: AppTextStyles.w400_12),
      ],
    );
  }
}

