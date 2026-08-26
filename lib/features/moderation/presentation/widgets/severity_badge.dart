import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/moderation/domain/entities/violation_severity.dart';

/// Small visual badge indicating severity level.
class SeverityBadge extends StatelessWidget {
  final ViolationSeverity severity;

  const SeverityBadge({super.key, required this.severity});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final (label, fg, bg) = switch (severity) {
      ViolationSeverity.low => (
        s.moderationSeverityLow,
        const Color(0xFF2563EB),
        const Color(0xFFEFF6FF),
      ),
      ViolationSeverity.medium => (
        s.moderationSeverityMedium,
        const Color(0xFFD97706),
        const Color(0xFFFEF3C7),
      ),
      ViolationSeverity.high => (
        s.moderationSeverityHigh,
        const Color(0xFFEA580C),
        const Color(0xFFFFEDD5),
      ),
      ViolationSeverity.critical => (
        s.moderationSeverityCritical,
        const Color(0xFFDC2626),
        const Color(0xFFFEE2E2),
      ),
      ViolationSeverity.unknown => (
        s.commonAll,
        const Color(0xFF6B7280),
        const Color(0xFFF3F4F6),
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.w600_12.copyWith(color: fg, fontSize: 10.sp),
      ),
    );
  }
}
