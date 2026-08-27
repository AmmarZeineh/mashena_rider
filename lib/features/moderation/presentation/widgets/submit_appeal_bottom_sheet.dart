import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_entity.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/submit_appeal_cubit/submit_appeal_cubit.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/submit_appeal_cubit/submit_appeal_state.dart';

class SubmitAppealBottomSheet extends StatefulWidget {
  final PenaltyEntity penalty;

  const SubmitAppealBottomSheet({super.key, required this.penalty});

  static Future<bool?> show(BuildContext context, PenaltyEntity penalty) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => getIt<SubmitAppealCubit>(),
        child: SubmitAppealBottomSheet(penalty: penalty),
      ),
    );
  }

  @override
  State<SubmitAppealBottomSheet> createState() =>
      _SubmitAppealBottomSheetState();
}

class _SubmitAppealBottomSheetState extends State<SubmitAppealBottomSheet> {
  final _reasonController = TextEditingController();
  final _evidenceController = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _reasonController.addListener(() {
      setState(() {
        _charCount = _reasonController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _evidenceController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<SubmitAppealCubit>().submit(
      penaltyId: widget.penalty.id,
      reason: _reasonController.text,
      evidence: _evidenceController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocConsumer<SubmitAppealCubit, SubmitAppealState>(
      listener: (context, state) {
        if (state.status == SubmitAppealStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(s.moderationAppealSuccess),
              backgroundColor: AppColors.shieldGreen,
            ),
          );
          Navigator.of(context).pop(true);
        } else if (state.status == SubmitAppealStatus.failure) {
          final errorMsg =
              state.failure?.rawMessage ??
              (state.failure?.statusCode == 400
                  ? s.moderationAppealAlreadyExists
                  : s.commonError);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final colorScheme = theme.colorScheme;
        final isSubmitting = state.status == SubmitAppealStatus.submitting;
        final timeColor = isDark ? colorScheme.onSurfaceVariant : AppColors.textGrey;

        final fieldBorder = OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark
                ? colorScheme.outlineVariant.withValues(alpha: 0.3)
                : AppColors.borderColor,
          ),
        );

        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
            left: 20.w,
            right: 20.w,
            top: 12.h,
          ),
          decoration: BoxDecoration(
            color: isDark ? colorScheme.surfaceContainerHigh : Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top drag handle
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark
                          ? colorScheme.outlineVariant
                          : AppColors.borderColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Title
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(
                          alpha: isDark ? 0.18 : 0.1,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.campaign_outlined,
                        color: AppColors.primaryColor,
                        size: 22,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.moderationSubmitAppeal,
                            style: AppTextStyles.w700_18.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            s.moderationPenaltyRef(widget.penalty.id),
                            style: AppTextStyles.w500_12.copyWith(
                              color: timeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Penalty reason snippet preview
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: isDark
                        ? colorScheme.surfaceContainerLow
                        : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: isDark
                          ? colorScheme.outlineVariant.withValues(alpha: 0.25)
                          : AppColors.borderColor,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.penalty.reason,
                        style: AppTextStyles.w500_14.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Reason input label & counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      s.moderationAppealReason,
                      style: AppTextStyles.w600_14.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '$_charCount / 2000',
                      style: AppTextStyles.w500_12.copyWith(
                        color: _charCount > 2000
                            ? AppColors.errorColor
                            : timeColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: _reasonController,
                  maxLines: 4,
                  maxLength: 2000,
                  style: AppTextStyles.w400_14.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  buildCounter: (
                    _, {
                    required currentLength,
                    required isFocused,
                    maxLength,
                  }) => null,
                  decoration: InputDecoration(
                    hintText: s.moderationAppealReasonHint,
                    hintStyle: AppTextStyles.w400_14.copyWith(
                      color: AppColors.textfieldHintGrey,
                    ),
                    filled: isDark,
                    fillColor: isDark ? colorScheme.surfaceContainerLow : null,
                    border: fieldBorder,
                    enabledBorder: fieldBorder,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(12.r),
                  ),
                ),
                if (state.validationError == 'REASON_REQUIRED')
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      s.moderationReasonRequired,
                      style: AppTextStyles.w500_12.copyWith(
                        color: AppColors.errorColor,
                      ),
                    ),
                  ),

                SizedBox(height: 14.h),

                // Evidence URL optional field
                Text(
                  s.moderationAppealEvidence,
                  style: AppTextStyles.w600_14.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: _evidenceController,
                  keyboardType: TextInputType.url,
                  style: AppTextStyles.w400_14.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: s.moderationAppealEvidenceHint,
                    hintStyle: AppTextStyles.w400_14.copyWith(
                      color: AppColors.textfieldHintGrey,
                    ),
                    filled: isDark,
                    fillColor: isDark ? colorScheme.surfaceContainerLow : null,
                    prefixIcon: Icon(
                      Icons.link,
                      size: 20,
                      color: isDark ? colorScheme.onSurfaceVariant : null,
                    ),
                    border: fieldBorder,
                    enabledBorder: fieldBorder,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
                if (state.validationError == 'INVALID_EVIDENCE_URL')
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      s.moderationInvalidEvidenceUrl,
                      style: AppTextStyles.w500_12.copyWith(
                        color: AppColors.errorColor,
                      ),
                    ),
                  ),

                SizedBox(height: 20.h),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: isSubmitting
                        ? null
                        : () => _handleSubmit(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: isSubmitting
                        ? SizedBox(
                            height: 20.r,
                            width: 20.r,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            s.moderationAppealSubmitBtn,
                            style: AppTextStyles.w600_16.copyWith(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
