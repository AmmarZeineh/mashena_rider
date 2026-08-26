import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/moderation/domain/entities/moderation_overview_entity.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/active_restriction_card.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/appeal_card.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/appeal_details_bottom_sheet.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/penalty_card.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/submit_appeal_bottom_sheet.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/violation_card.dart';

class OverviewTabView extends StatelessWidget {
  final ModerationOverviewEntity overview;
  final VoidCallback onRefreshNeeded;

  const OverviewTabView({
    super.key,
    required this.overview,
    required this.onRefreshNeeded,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final hasContent =
        overview.activeRestrictions.isNotEmpty ||
        overview.activePenalties.isNotEmpty ||
        overview.recentViolations.isNotEmpty ||
        overview.activeAppeals.isNotEmpty;

    if (!hasContent) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: AppColors.shieldGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 56.r,
                color: AppColors.shieldGreen,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              s.moderationNoRestrictions,
              style: AppTextStyles.w600_16.copyWith(color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      children: [
        // Active Restrictions Section
        if (overview.activeRestrictions.isNotEmpty) ...[
          Text(s.moderationActiveRestrictions, style: AppTextStyles.w700_16),
          SizedBox(height: 10.h),
          ...overview.activeRestrictions.map(
            (r) => ActiveRestrictionCard(restriction: r),
          ),
          SizedBox(height: 16.h),
        ],

        // Active Penalties Section
        if (overview.activePenalties.isNotEmpty) ...[
          Text(s.moderationActivePenalties, style: AppTextStyles.w700_16),
          SizedBox(height: 10.h),
          ...overview.activePenalties.map(
            (p) => PenaltyCard(
              penalty: p,
              onAppealTap: () async {
                final appealed = await SubmitAppealBottomSheet.show(context, p);
                if (appealed == true) {
                  onRefreshNeeded();
                }
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],

        // Recent Violations Section
        if (overview.recentViolations.isNotEmpty) ...[
          Text(s.moderationRecentViolations, style: AppTextStyles.w700_16),
          SizedBox(height: 10.h),
          ...overview.recentViolations.map((v) => ViolationCard(violation: v)),
          SizedBox(height: 16.h),
        ],

        // Active Appeals Section
        if (overview.activeAppeals.isNotEmpty) ...[
          Text(s.moderationActiveAppeals, style: AppTextStyles.w700_16),
          SizedBox(height: 10.h),
          ...overview.activeAppeals.map(
            (a) => AppealCard(
              appeal: a,
              onTap: () => AppealDetailsBottomSheet.show(context, a),
            ),
          ),
          SizedBox(height: 16.h),
        ],

        SizedBox(height: 24.h),
      ],
    );
  }
}
