import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';

class TripDetails extends StatelessWidget {
  const TripDetails({super.key, required this.submissionResponse});

  final RideSubmissionResponse submissionResponse;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _DetailItem(
          icon: Icons.attach_money_rounded,
          value:
              '${submissionResponse.currency} ${_formatNum(submissionResponse.estimatedFare)}',
          label: S.of(context).rideEstFare,
          color: Colors.green,
        ),
        Container(width: 1, height: 30.h, color: colorScheme.outlineVariant),
        _DetailItem(
          icon: Icons.speed_rounded,
          value: S
              .of(context)
              .rideDistanceKm(_formatNum(submissionResponse.distanceKm)),
          label: S.of(context).rideDistance,
          color: colorScheme.primary,
        ),
        Container(width: 1, height: 30.h, color: colorScheme.outlineVariant),
        _DetailItem(
          icon: Icons.access_time_rounded,
          value: S
              .of(context)
              .rideDurationMin(_formatNum(submissionResponse.durationMin)),
          label: S.of(context).rideDuration,
          color: colorScheme.secondary,
        ),
      ],
    );
  }

  static String _formatNum(double value) => value.truncateToDouble() == value
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTextStyles.w700_16.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.w500_12.copyWith(color: AppColors.textGrey),
        ),
      ],
    );
  }
}
