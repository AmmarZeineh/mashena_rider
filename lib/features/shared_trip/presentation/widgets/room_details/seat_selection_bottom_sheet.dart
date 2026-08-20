import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_room_details_entity.dart';

class SeatSelectionBottomSheet extends StatefulWidget {
  final SharedRideRoomDetailsEntity details;
  final void Function(int seatsNeeded) onConfirm;

  const SeatSelectionBottomSheet({
    super.key,
    required this.details,
    required this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required SharedRideRoomDetailsEntity details,
    required void Function(int seatsNeeded) onConfirm,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? colorScheme.surfaceContainerLow : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) =>
          SeatSelectionBottomSheet(details: details, onConfirm: onConfirm),
    );
  }

  @override
  State<SeatSelectionBottomSheet> createState() =>
      _SeatSelectionBottomSheetState();
}

class _SeatSelectionBottomSheetState extends State<SeatSelectionBottomSheet> {
  int _selectedSeats = 1;

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

    final maxAvailable = widget.details.availableSeats.clamp(
      1,
      widget.details.maxPassengers,
    );
    final totalFare = _selectedSeats * widget.details.effectiveSeatFare;

    final boxBg = isDark
        ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.6)
        : Colors.grey.shade50;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.3)
        : AppColors.borderColor.withValues(alpha: 0.6);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20.w,
        14.h,
        20.w,
        MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 44.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.outlineVariant
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Title & Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                s.sharedTripSelectSeatsTitle,
                style: AppTextStyles.w700_18.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
                splashRadius: 20.r,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Counter Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: boxBg,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.sharedTripSeatsNeeded,
                      style: AppTextStyles.w600_14.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      s.sharedTripFreeSeats(maxAvailable),
                      style: AppTextStyles.w400_12.copyWith(
                        color: AppColors.shieldGreen,
                      ),
                    ),
                  ],
                ),

                // Increment / Decrement Buttons
                Row(
                  children: [
                    _buildCounterButton(
                      icon: Icons.remove_rounded,
                      isEnabled: _selectedSeats > 1,
                      isDark: isDark,
                      colorScheme: colorScheme,
                      onTap: () {
                        if (_selectedSeats > 1) {
                          setState(() {
                            _selectedSeats--;
                          });
                        }
                      },
                    ),
                    SizedBox(width: 14.w),
                    Container(
                      constraints: BoxConstraints(minWidth: 32.w),
                      alignment: Alignment.center,
                      child: Text(
                        '$_selectedSeats',
                        style: AppTextStyles.w700_20.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    _buildCounterButton(
                      icon: Icons.add_rounded,
                      isEnabled: _selectedSeats < maxAvailable,
                      isDark: isDark,
                      colorScheme: colorScheme,
                      onTap: () {
                        if (_selectedSeats < maxAvailable) {
                          setState(() {
                            _selectedSeats++;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Fare Summary Card
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(
                alpha: isDark ? 0.12 : 0.04,
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.primaryColor.withValues(
                  alpha: isDark ? 0.35 : 0.2,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      s.sharedTripFarePerSeat,
                      style: AppTextStyles.w400_14.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                    Text(
                      '${_formatFare(widget.details.effectiveSeatFare)} ${s.currencySyp}',
                      style: AppTextStyles.w500_14.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.primaryColor.withValues(
                      alpha: isDark ? 0.3 : 0.2,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      s.paymentTotal,
                      style: AppTextStyles.w700_16.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          _formatFare(totalFare),
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
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Confirm Action Button
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onConfirm(_selectedSeats);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: Text(
              s.sharedTripConfirmJoin,
              style: AppTextStyles.w600_16.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required bool isEnabled,
    required bool isDark,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    final disabledBg = isDark
        ? colorScheme.surfaceContainerHighest
        : Colors.grey.shade200;

    return Material(
      color: isEnabled
          ? AppColors.primaryColor.withValues(alpha: isDark ? 0.2 : 0.1)
          : disabledBg,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 36.r,
          height: 36.r,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 20.r,
            color: isEnabled ? AppColors.primaryColor : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
