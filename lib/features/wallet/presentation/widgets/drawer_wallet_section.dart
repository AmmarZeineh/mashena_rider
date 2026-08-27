import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import '../cubits/wallet_cubit/wallet_cubit.dart';
import '../cubits/wallet_cubit/wallet_state.dart';
import 'wallet_transactions_bottom_sheet.dart';

class DrawerWalletSection extends StatelessWidget {
  const DrawerWalletSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final s = S.of(context);

    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        if (state.isLoading) {
          return _WalletLoadingCard(isDark: isDark, colorScheme: colorScheme);
        }

        if (state.status == WalletStatus.error && !state.hasData) {
          return _WalletErrorCard(
            isDark: isDark,
            colorScheme: colorScheme,
            message: s.walletErrorLoading,
            retryLabel: s.walletRetry,
            onRetry: () => context.read<WalletCubit>().fetchWallet(),
          );
        }

        final wallet = state.wallet;
        if (wallet == null) {
          return const SizedBox.shrink();
        }

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          child: InkWell(
            onTap: () => WalletTransactionsBottomSheet.show(context, wallet),
            borderRadius: BorderRadius.circular(16.r),
            splashColor: AppColors.primaryColor.withValues(alpha: 0.12),
            highlightColor: AppColors.primaryColor.withValues(alpha: 0.06),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          colorScheme.surfaceContainerHigh.withValues(
                            alpha: 0.8,
                          ),
                          AppColors.primaryColor.withValues(alpha: 0.15),
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
                      : AppColors.primaryColor.withValues(alpha: 0.2),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header row: Icon + Wallet title + Active status badge + Forward arrow
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(
                            alpha: isDark ? 0.25 : 0.12,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          color: AppColors.primaryColor,
                          size: 16.r,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        s.drawerWallet,
                        style: AppTextStyles.w600_14.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      _DrawerStatusPill(
                        isActive: wallet.isActive,
                        activeLabel: s.walletStatusActive,
                        inactiveLabel: s.walletStatusInactive,
                      ),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12.r,
                        color: isDark
                            ? colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.7,
                              )
                            : AppColors.textGrey.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  // Formatted Balance + Refresh button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.walletBalance,
                            style: AppTextStyles.w400_11.copyWith(
                              color: isDark
                                  ? colorScheme.onSurfaceVariant
                                  : AppColors.textGrey,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            wallet.formattedBalance,
                            style: AppTextStyles.w700_18.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: state.isRefreshing
                            ? null
                            : () => context.read<WalletCubit>().refreshWallet(),
                        borderRadius: BorderRadius.circular(20.r),
                        child: Padding(
                          padding: EdgeInsets.all(6.r),
                          child: state.isRefreshing
                              ? SizedBox(
                                  width: 16.r,
                                  height: 16.r,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : Icon(
                                  Icons.refresh_rounded,
                                  size: 18.r,
                                  color: isDark
                                      ? colorScheme.onSurfaceVariant
                                      : AppColors.textGrey,
                                ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  // Visual Hint Chip that Wallet is Pressable
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(
                        alpha: isDark ? 0.15 : 0.07,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.receipt_long_rounded,
                          size: 13.r,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            s.walletTapToViewTransactions,
                            style: AppTextStyles.w500_11.copyWith(
                              color: AppColors.primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 16.r,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DrawerStatusPill extends StatelessWidget {
  final bool isActive;
  final String activeLabel;
  final String inactiveLabel;

  const _DrawerStatusPill({
    required this.isActive,
    required this.activeLabel,
    required this.inactiveLabel,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.shieldGreen : AppColors.textGrey;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.r,
            height: 5.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 4.w),
          Text(
            isActive ? activeLabel : inactiveLabel,
            style: AppTextStyles.w600_10.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _WalletLoadingCard extends StatelessWidget {
  final bool isDark;
  final ColorScheme colorScheme;

  const _WalletLoadingCard({required this.isDark, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.4)
            : AppColors.primaryColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant.withValues(alpha: 0.15)
              : AppColors.primaryColor.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: SizedBox(
                width: 14.r,
                height: 14.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: 0.08,
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  width: 90.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: 0.08,
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletErrorCard extends StatelessWidget {
  final bool isDark;
  final ColorScheme colorScheme;
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  const _WalletErrorCard({
    required this.isDark,
    required this.colorScheme,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.errorColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.errorColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 20.r,
            color: AppColors.errorColor,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.w400_12.copyWith(
                color: isDark ? colorScheme.onSurface : AppColors.textGrey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              retryLabel,
              style: AppTextStyles.w600_12.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
