import 'package:flutter/material.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';

class ProximityWarning extends StatelessWidget {
  const ProximityWarning({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.w400_12.copyWith(
                    color: Colors.orange[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
