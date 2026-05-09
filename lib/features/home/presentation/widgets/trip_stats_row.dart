import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';

class TripStatsRow extends StatelessWidget {
  const TripStatsRow({super.key, required this.response});

  final RideEstimateResponse response;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        _buildStat(
          context,
          icon: Icons.speed_rounded,
          value: _formatNum(response.distanceKm),
          unit: 'km',
          color: colorScheme.primary,
        ),
        _buildDivider(context),
        _buildStat(
          context,
          icon: Icons.access_time_rounded,
          value: _formatNum(response.durationMin),
          unit: 'min',
          color: colorScheme.secondary,
        ),
        if (response.stopsCount > 0) ...[
          _buildDivider(context),
          _buildStat(
            context,
            icon: Icons.place_rounded,
            value: response.stopsCount.toString(),
            unit: 'stops',
            color: colorScheme.tertiary,
          ),
        ],
      ],
    );
  }

  Widget _buildStat(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18.sp, color: color.withValues(alpha: 0.7)),
          SizedBox(width: 8.w),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: AppTextStyles.w800_16.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: AppTextStyles.w500_12.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 24.h,
      width: 1.w,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.5),
    );
  }

  /// Formats a [double] without a trailing `.0`.
  static String _formatNum(double value) => value.truncateToDouble() == value
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
}
