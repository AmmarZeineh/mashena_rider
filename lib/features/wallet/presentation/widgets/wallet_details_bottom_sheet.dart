import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import '../../domain/entities/wallet_entity.dart';

class WalletDetailsBottomSheet extends StatelessWidget {
  final WalletEntity wallet;

  const WalletDetailsBottomSheet({super.key, required this.wallet});

  static Future<void> show(BuildContext context, WalletEntity wallet) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => WalletDetailsBottomSheet(wallet: wallet),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final s = S.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 12.h,
        bottom: MediaQuery.of(context).padding.bottom + 16.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.outlineVariant.withValues(alpha: 0.5)
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
                    alpha: isDark ? 0.2 : 0.1,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.primaryColor,
                  size: 22.r,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                s.walletDetails,
                style: AppTextStyles.w700_18.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
                color: isDark
                    ? colorScheme.onSurfaceVariant
                    : AppColors.textGrey,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Balance Highlight Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.primaryColor.withValues(alpha: 0.25),
                        colorScheme.surfaceContainerHigh,
                      ]
                    : [
                        AppColors.primaryColor.withValues(alpha: 0.08),
                        AppColors.primaryColor.withValues(alpha: 0.02),
                      ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDark
                    ? colorScheme.outlineVariant.withValues(alpha: 0.3)
                    : AppColors.primaryColor.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      s.walletBalance,
                      style: AppTextStyles.w500_14.copyWith(
                        color: isDark
                            ? colorScheme.onSurfaceVariant
                            : AppColors.textGrey,
                      ),
                    ),
                    _StatusPill(
                      isActive: wallet.isActive,
                      activeLabel: s.walletStatusActive,
                      inactiveLabel: s.walletStatusInactive,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  wallet.formattedBalance,
                  style: AppTextStyles.w700_30.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Information list items
          _InfoTile(
            label: s.walletId,
            value: '#${wallet.id}',
            icon: Icons.tag_rounded,
          ),
          if (wallet.user != null && wallet.user!.fullName.isNotEmpty)
            _InfoTile(
              label: s.drawerMyAccount,
              value: wallet.user!.fullName,
              icon: Icons.person_outline_rounded,
            ),
          if (wallet.user != null && wallet.user!.phoneNumber.isNotEmpty)
            _InfoTile(
              label: 'Phone',
              value: wallet.user!.phoneNumber,
              icon: Icons.phone_outlined,
            ),
          if (wallet.user != null && wallet.user!.email.isNotEmpty)
            _InfoTile(
              label: 'Email',
              value: wallet.user!.email,
              icon: Icons.email_outlined,
            ),
          if (wallet.createdAt != null)
            _InfoTile(
              label: s.walletCreatedAt,
              value: _formatDate(wallet.createdAt!),
              icon: Icons.calendar_today_outlined,
            ),
          if (wallet.updatedAt != null)
            _InfoTile(
              label: s.walletUpdatedAt,
              value: _formatDate(wallet.updatedAt!),
              icon: Icons.update_rounded,
            ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusPill extends StatelessWidget {
  final bool isActive;
  final String activeLabel;
  final String inactiveLabel;

  const _StatusPill({
    required this.isActive,
    required this.activeLabel,
    required this.inactiveLabel,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.shieldGreen : AppColors.textGrey;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 5.w),
          Text(
            isActive ? activeLabel : inactiveLabel,
            style: AppTextStyles.w600_12.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.r,
            color: isDark ? colorScheme.onSurfaceVariant : AppColors.textGrey,
          ),
          SizedBox(width: 10.w),
          Text(
            label,
            style: AppTextStyles.w400_14.copyWith(
              color: isDark ? colorScheme.onSurfaceVariant : AppColors.textGrey,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.w600_14.copyWith(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
