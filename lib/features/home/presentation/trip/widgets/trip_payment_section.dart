import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/widgets/custom_elevated_button.dart';
import '../cubits/trip_rating_state.dart';

class TripPaymentSection extends StatelessWidget {
  final TripRatingState state;
  final num fare;
  final String currency;
  final ValueChanged<TripPaymentMethod> onMethodChanged;
  final VoidCallback onPayWithWallet;

  const TripPaymentSection({
    super.key,
    required this.state,
    required this.fare,
    required this.currency,
    required this.onMethodChanged,
    required this.onPayWithWallet,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            s.paymentMethodTitle,
            style: AppTextStyles.w600_16.copyWith(color: colorScheme.onSurface),
          ),
          SizedBox(height: 12.h),

          // Payment Method Selector (Cash vs Wallet)
          Row(
            children: [
              Expanded(
                child: _PaymentMethodCard(
                  title: s.paymentMethodCash,
                  icon: Icons.payments_outlined,
                  isSelected: state.paymentMethod == TripPaymentMethod.cash,
                  isDisabled: state.isWalletPaid,
                  onTap: () => onMethodChanged(TripPaymentMethod.cash),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _PaymentMethodCard(
                  title: s.paymentMethodWallet,
                  icon: Icons.account_balance_wallet_outlined,
                  isSelected: state.paymentMethod == TripPaymentMethod.wallet,
                  isCompleted: state.isWalletPaid,
                  badge: state.walletBalance != null && !state.isWalletPaid
                      ? "${state.walletBalance!.toStringAsFixed(0)} $currency"
                      : null,
                  onTap: () => onMethodChanged(TripPaymentMethod.wallet),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Content based on selected method
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: state.paymentMethod == TripPaymentMethod.cash
                ? _buildCashDetails(context, colorScheme, s)
                : _buildWalletDetails(context, colorScheme, isDark, s),
          ),
        ],
      ),
    );
  }

  Widget _buildCashDetails(BuildContext context, ColorScheme colorScheme, S s) {
    return Container(
      key: const ValueKey('cash_details'),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20.r,
            color: colorScheme.primary,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              "${s.paymentMethodCashDesc} (${fare.toStringAsFixed(0)} $currency)",
              style: AppTextStyles.w500_12.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletDetails(
    BuildContext context,
    ColorScheme colorScheme,
    bool isDark,
    S s,
  ) {
    if (state.isWalletPaid) {
      return Container(
        key: const ValueKey('wallet_paid'),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.shieldGreen.withValues(alpha: isDark ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColors.shieldGreen.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: const BoxDecoration(
                color: AppColors.shieldGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_rounded, size: 16.r, color: Colors.white),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.paymentWalletSuccess,
                    style: AppTextStyles.w600_14.copyWith(
                      color: AppColors.shieldGreen,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    s.paymentWalletSuccessDesc(
                      fare.toStringAsFixed(0),
                      (state.walletBalance ?? 0).toStringAsFixed(0),
                      currency,
                    ),
                    style: AppTextStyles.w400_11.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (state.isLoadingWallet) {
      return Container(
        key: const ValueKey('wallet_loading'),
        padding: EdgeInsets.all(16.r),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      );
    }

    final balance = state.walletBalance ?? 0;
    final hasEnoughBalance = balance >= fare;

    return Container(
      key: const ValueKey('wallet_unpaid'),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                s.paymentWalletAvailableBalance(
                  balance.toStringAsFixed(0),
                  currency,
                ),
                style: AppTextStyles.w500_12.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (!hasEnoughBalance)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.errorColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    "رصيد غير كافٍ",
                    style: AppTextStyles.w600_10.copyWith(
                      color: AppColors.errorColor,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          if (hasEnoughBalance)
            CustomElevatedButton(
              title: s.paymentWalletPayNow(fare.toStringAsFixed(0), currency),
              isLoading: state.isPayingWithWallet,
              onPressed: onPayWithWallet,
            )
          else
            Text(
              s.paymentWalletInsufficient,
              style: AppTextStyles.w500_12.copyWith(
                color: AppColors.errorColor,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final bool isDisabled;
  final bool isCompleted;
  final String? badge;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    this.isDisabled = false,
    this.isCompleted = false,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final selectedBorderColor = isCompleted
        ? AppColors.shieldGreen
        : AppColors.primaryColor;
    final selectedBgColor = isCompleted
        ? AppColors.shieldGreen.withValues(alpha: isDark ? 0.2 : 0.1)
        : AppColors.primaryColor.withValues(alpha: isDark ? 0.2 : 0.08);

    final borderColor = isSelected
        ? selectedBorderColor
        : (isDark ? Colors.white12 : Colors.grey.shade300);
    final bgColor = isSelected
        ? selectedBgColor
        : (isDark ? colorScheme.surfaceContainerHigh : colorScheme.surface);

    final primaryTextColor = isSelected
        ? (isCompleted ? AppColors.shieldGreen : AppColors.primaryColor)
        : colorScheme.onSurface;

    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 1.8 : 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, size: 24.r, color: primaryTextColor),
                    if (isCompleted)
                      Icon(
                        Icons.check_circle_rounded,
                        size: 20.r,
                        color: AppColors.shieldGreen,
                      )
                    else
                      Container(
                        width: 20.r,
                        height: 20.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryColor
                                : (isDark
                                      ? Colors.white38
                                      : Colors.grey.shade400),
                            width: isSelected ? 6.r : 1.5.r,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  title,
                  style: AppTextStyles.w600_14.copyWith(
                    color: primaryTextColor,
                  ),
                ),
                if (badge != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    badge!,
                    style: AppTextStyles.w400_11.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
