import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/toast_helper.dart';
import 'package:mashena_rider/core/widgets/custom_form_field.dart';

class CouponInputCard extends StatefulWidget {
  final ValueChanged<String>? onApply;
  final bool isLoading;

  const CouponInputCard({super.key, this.onApply, this.isLoading = false});

  @override
  State<CouponInputCard> createState() => _CouponInputCardState();
}

class _CouponInputCardState extends State<CouponInputCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleApply() {
    if (widget.isLoading) return;

    final code = _controller.text.trim();
    if (code.isNotEmpty) {
      widget.onApply?.call(code);
    } else {
      context.showErrorToast(S.of(context).enterValidCouponCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.7)
            : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant.withValues(alpha: 0.25)
              : AppColors.borderColor.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).applyCouponTitle,
            style: AppTextStyles.w600_16.copyWith(
              color: isDark ? colorScheme.onSurface : AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: CustomFormField(
                  controller: _controller,
                  hint: S.of(context).enterCouponHint,
                  prefix: Padding(
                    padding: EdgeInsets.only(right: 8.w, left: 4.w),
                    child: Icon(
                      Icons.confirmation_number_outlined,
                      color: AppColors.primaryColor,
                      size: 20.r,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              SizedBox(
                height: 48.h,
                child: ElevatedButton(
                  onPressed: widget.isLoading ? null : _handleApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primaryColor.withValues(
                      alpha: 0.6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    elevation: 0,
                  ),
                  child: widget.isLoading
                      ? SizedBox(
                          width: 20.r,
                          height: 20.r,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          S.of(context).applyButton,
                          style: AppTextStyles.w600_14.copyWith(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
