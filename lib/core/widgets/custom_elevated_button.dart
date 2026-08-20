import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;
    final Color effectiveBgColor = backgroundColor ?? AppColors.primaryColor;
    final Color effectiveTextColor = textColor ?? Colors.white;

    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled
            ? effectiveBgColor
            : effectiveBgColor.withValues(alpha: 0.5),
        disabledBackgroundColor: effectiveBgColor.withValues(alpha: 0.5),
        elevation: isEnabled ? 2 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: CircularProgressIndicator(
                  color: effectiveTextColor,
                  strokeWidth: 2,
                ),
              )
            : Text(
                title,
                style: AppTextStyles.w600_18.copyWith(
                  color: effectiveTextColor.withValues(
                    alpha: isEnabled ? 1 : 0.7,
                  ),
                ),
              ),
      ),
    );
  }
}
