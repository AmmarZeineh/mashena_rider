import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import '../../domain/entities/wallet_transaction_entity.dart';

class WalletTransactionCard extends StatelessWidget {
  final WalletTransactionEntity transaction;
  final String currency;

  const WalletTransactionCard({
    super.key,
    required this.transaction,
    this.currency = 'SYR',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final s = S.of(context);

    final isDeposit = transaction.isDeposit;
    final isWithdraw = transaction.isWithdraw;

    final Color accentColor = isDeposit
        ? AppColors.shieldGreen
        : (isWithdraw ? AppColors.errorColor : AppColors.primaryColor);

    final IconData icon = isDeposit
        ? Icons.south_west_rounded
        : (isWithdraw ? Icons.north_east_rounded : Icons.swap_horiz_rounded);

    final String typeTitle = _mapTypeToTitle(transaction.type, s);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.5)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant.withValues(alpha: 0.2)
              : AppColors.borderColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Transaction Type Icon
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: accentColor, size: 20.r),
          ),
          SizedBox(width: 12.w),
          // Type & Date/Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  typeTitle,
                  style: AppTextStyles.w600_14.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  _formatDate(transaction.createdAt),
                  style: AppTextStyles.w400_11.copyWith(
                    color: isDark
                        ? colorScheme.onSurfaceVariant
                        : AppColors.textGrey,
                  ),
                ),
                if (transaction.description != null &&
                    transaction.description!.trim().isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    transaction.description!,
                    style: AppTextStyles.w400_11.copyWith(
                      color: isDark
                          ? colorScheme.onSurfaceVariant
                          : AppColors.textGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // Amount & Resulting Balance
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.formattedAmount(currency),
                style: AppTextStyles.w700_16.copyWith(color: accentColor),
              ),
              SizedBox(height: 3.h),
              Text(
                '${s.walletBalanceAfter}: ${transaction.balanceAfter.toInt()} $currency',
                style: AppTextStyles.w400_11.copyWith(
                  color: isDark
                      ? colorScheme.onSurfaceVariant.withValues(alpha: 0.7)
                      : AppColors.textGrey.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _mapTypeToTitle(String type, S s) {
    switch (type.toUpperCase()) {
      case 'DEPOSIT':
        return s.walletDeposit;
      case 'WITHDRAW':
        return s.walletWithdraw;
      case 'TRANSFER':
        return s.walletTransfer;
      case 'TRIP_PAYMENT':
      case 'RIDE_PAYMENT':
        return s.walletTripPayment;
      default:
        return type;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} • '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
