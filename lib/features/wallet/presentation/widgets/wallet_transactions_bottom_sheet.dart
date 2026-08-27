import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/constants/app_pagination.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import '../../domain/entities/wallet_entity.dart';
import '../cubits/wallet_transactions_cubit/wallet_transactions_cubit.dart';
import '../cubits/wallet_transactions_cubit/wallet_transactions_state.dart';
import 'wallet_transaction_card.dart';

class WalletTransactionsBottomSheet extends StatefulWidget {
  final WalletEntity wallet;

  const WalletTransactionsBottomSheet({super.key, required this.wallet});

  static Future<void> show(BuildContext context, WalletEntity wallet) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => WalletTransactionsBottomSheet(wallet: wallet),
    );
  }

  @override
  State<WalletTransactionsBottomSheet> createState() =>
      _WalletTransactionsBottomSheetState();
}

class _WalletTransactionsBottomSheetState
    extends State<WalletTransactionsBottomSheet> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (maxScroll - currentScroll <= AppPagination.loadMoreThreshold) {
      context.read<WalletTransactionsCubit>().loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<WalletTransactionsCubit>()..fetchInitialTransactions(),
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          final isDark = theme.brightness == Brightness.dark;
          final s = S.of(context);
          final sheetHeight = MediaQuery.of(context).size.height * 0.85;

          return Container(
            height: sheetHeight,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Column(
              children: [
                SizedBox(height: 12.h),
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
                SizedBox(height: 14.h),
                // Header Row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
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
                          size: 20.r,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        s.walletTransactionsHistory,
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
                ),
                SizedBox(height: 10.h),
                // Balance Banner
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.walletBalance,
                              style: AppTextStyles.w400_12.copyWith(
                                color: isDark
                                    ? colorScheme.onSurfaceVariant
                                    : AppColors.textGrey,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              widget.wallet.formattedBalance,
                              style: AppTextStyles.w700_24.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (widget.wallet.isActive
                                        ? AppColors.shieldGreen
                                        : AppColors.textGrey)
                                    .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6.r,
                                height: 6.r,
                                decoration: BoxDecoration(
                                  color: widget.wallet.isActive
                                      ? AppColors.shieldGreen
                                      : AppColors.textGrey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                widget.wallet.isActive
                                    ? s.walletStatusActive
                                    : s.walletStatusInactive,
                                style: AppTextStyles.w600_12.copyWith(
                                  color: widget.wallet.isActive
                                      ? AppColors.shieldGreen
                                      : AppColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Section Title Row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.walletTransactions,
                        style: AppTextStyles.w600_16.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      BlocBuilder<
                        WalletTransactionsCubit,
                        WalletTransactionsState
                      >(
                        builder: (context, state) {
                          if (state.totalCount > 0) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                '${state.totalCount}',
                                style: AppTextStyles.w600_12.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                // Transactions List
                Expanded(
                  child:
                      BlocBuilder<
                        WalletTransactionsCubit,
                        WalletTransactionsState
                      >(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return _buildLoadingList(isDark, colorScheme);
                          }

                          if (state.isFailure && state.items.isEmpty) {
                            return _buildErrorView(context, s);
                          }

                          if (state.isEmpty) {
                            return _buildEmptyView(s, isDark, colorScheme);
                          }

                          return RefreshIndicator(
                            color: AppColors.primaryColor,
                            onRefresh: () => context
                                .read<WalletTransactionsCubit>()
                                .refreshTransactions(),
                            child: ListView.separated(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 8.h,
                              ),
                              itemCount:
                                  state.items.length +
                                  (state.isLoadingMore ? 1 : 0),
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 8.h),
                              itemBuilder: (context, index) {
                                if (index >= state.items.length) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                    ),
                                    child: const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                final item = state.items[index];
                                return WalletTransactionCard(
                                  transaction: item,
                                  currency: widget.wallet.currency,
                                );
                              },
                            ),
                          );
                        },
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingList(bool isDark, ColorScheme colorScheme) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      itemCount: 4,
      separatorBuilder: (_, _) => SizedBox(height: 8.h),
      itemBuilder: (_, _) => Container(
        height: 64.h,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isDark
              ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.3)
              : AppColors.borderColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, S s) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 40.r,
            color: AppColors.errorColor,
          ),
          SizedBox(height: 10.h),
          Text(
            s.walletErrorLoading,
            style: AppTextStyles.w500_14.copyWith(color: AppColors.textGrey),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () => context
                .read<WalletTransactionsCubit>()
                .fetchInitialTransactions(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              s.walletRetry,
              style: AppTextStyles.w600_14.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(S s, bool isDark, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(
                alpha: isDark ? 0.2 : 0.08,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 28.r,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            s.walletNoTransactions,
            style: AppTextStyles.w500_14.copyWith(
              color: isDark ? colorScheme.onSurfaceVariant : AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
