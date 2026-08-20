import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_room_details_entity.dart';

class RoomDetailsBottomBar extends StatelessWidget {
  final SharedRideRoomDetailsEntity details;
  final VoidCallback? onJoinPressed;

  const RoomDetailsBottomBar({
    super.key,
    required this.details,
    this.onJoinPressed,
  });

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

    final canJoin = details.isOpen && !details.isFull;
    final barBg = isDark ? colorScheme.surfaceContainerLow : Colors.white;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.3)
        : AppColors.borderColor.withValues(alpha: 0.5);

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: barBg,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Fare Summary
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.sharedTripFarePerSeat,
                    style: AppTextStyles.w400_12.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        _formatFare(details.effectiveSeatFare),
                        style: AppTextStyles.w700_20.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        s.currencySyp,
                        style: AppTextStyles.w600_12.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // CTA Button
            SizedBox(width: 16.w),
            FilledButton(
              onPressed: canJoin ? onJoinPressed : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                disabledBackgroundColor: isDark
                    ? colorScheme.surfaceContainerHighest
                    : Colors.grey.shade300,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                canJoin
                    ? s.sharedTripJoinRoom
                    : (details.isFull
                          ? s.sharedTripRoomFull
                          : s.sharedTripRoomClosed),
                style: AppTextStyles.w600_14.copyWith(
                  color: canJoin
                      ? Colors.white
                      : (isDark
                            ? colorScheme.onSurfaceVariant
                            : AppColors.textGrey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
