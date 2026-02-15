import 'package:flutter/material.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';

class SavedPlaceTile extends StatelessWidget {
  const SavedPlaceTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.favorite_border, color: Colors.black),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.w500_14),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.w400_12.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
