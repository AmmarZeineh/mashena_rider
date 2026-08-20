import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_room_details_entity.dart';

class RoomDetailsFareSection extends StatelessWidget {
  final SharedRideRoomDetailsEntity details;

  const RoomDetailsFareSection({super.key, required this.details});

  String _formatFare(num fare) {
    try {
      final formatter = NumberFormat('#,###');
      return formatter.format(fare);
    } catch (_) {
      return fare.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark ? colorScheme.surfaceContainerLow : Colors.white;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.3)
        : AppColors.borderColor.withValues(alpha: 0.5);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                size: 18.r,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                s.paymentTotal,
                style: AppTextStyles.w600_16.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Primary Seat Fare Row
          _buildFareRow(
            title: s.sharedTripFullFare,
            value: '${_formatFare(details.effectiveSeatFare)} ${s.currencySyp}',
            isHighlight: true,
            colorScheme: colorScheme,
          ),

          if (details.minimumSeatFare != null) ...[
            SizedBox(height: 8.h),
            _buildFareRow(
              title: s.sharedTripMinFare,
              value:
                  '${_formatFare(details.minimumSeatFare!)} ${s.currencySyp}',
              isHighlight: false,
              colorScheme: colorScheme,
            ),
          ],

          if (details.baseTripFare != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Divider(height: 1, thickness: 0.5, color: borderColor),
            ),
            _buildFareRow(
              title: s.sharedTripBaseCost,
              value: '${_formatFare(details.baseTripFare!)} ${s.currencySyp}',
              isHighlight: false,
              colorScheme: colorScheme,
              isSecondary: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFareRow({
    required String title,
    required String value,
    required bool isHighlight,
    required ColorScheme colorScheme,
    bool isSecondary = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isSecondary
              ? AppTextStyles.w400_12.copyWith(color: AppColors.textGrey)
              : AppTextStyles.w500_14.copyWith(color: colorScheme.onSurface),
        ),
        Text(
          value,
          style: isHighlight
              ? AppTextStyles.w700_16.copyWith(color: AppColors.primaryColor)
              : (isSecondary
                    ? AppTextStyles.w500_12.copyWith(color: AppColors.textGrey)
                    : AppTextStyles.w600_14.copyWith(
                        color: colorScheme.onSurface,
                      )),
        ),
      ],
    );
  }
}
