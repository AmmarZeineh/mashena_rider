import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/constants/app_pagination.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_status.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/penalties_history_cubit/penalties_history_cubit.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/penalties_history_cubit/penalties_history_state.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/penalty_card.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/submit_appeal_bottom_sheet.dart';

class PenaltiesTabView extends StatefulWidget {
  final VoidCallback onRefreshOverview;

  const PenaltiesTabView({super.key, required this.onRefreshOverview});

  @override
  State<PenaltiesTabView> createState() => _PenaltiesTabViewState();
}

class _PenaltiesTabViewState extends State<PenaltiesTabView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
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
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= AppPagination.loadMoreThreshold) {
      context.read<PenaltiesHistoryCubit>().loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      children: [
        // Filter row
        BlocBuilder<PenaltiesHistoryCubit, PenaltiesHistoryState>(
          buildWhen: (p, c) => p.filterStatus != c.filterStatus,
          builder: (context, state) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  _FilterChip(
                    label: s.commonAll,
                    isSelected: state.filterStatus == null,
                    onTap: () => context
                        .read<PenaltiesHistoryCubit>()
                        .setFilterStatus(null),
                  ),
                  SizedBox(width: 8.w),
                  _FilterChip(
                    label: s.moderationPenaltyStatusActive,
                    isSelected: state.filterStatus == PenaltyStatus.active,
                    onTap: () => context
                        .read<PenaltiesHistoryCubit>()
                        .setFilterStatus(PenaltyStatus.active),
                  ),
                  SizedBox(width: 8.w),
                  _FilterChip(
                    label: s.moderationPenaltyStatusExpired,
                    isSelected: state.filterStatus == PenaltyStatus.expired,
                    onTap: () => context
                        .read<PenaltiesHistoryCubit>()
                        .setFilterStatus(PenaltyStatus.expired),
                  ),
                  SizedBox(width: 8.w),
                  _FilterChip(
                    label: s.moderationPenaltyStatusRevoked,
                    isSelected: state.filterStatus == PenaltyStatus.revoked,
                    onTap: () => context
                        .read<PenaltiesHistoryCubit>()
                        .setFilterStatus(PenaltyStatus.revoked),
                  ),
                ],
              ),
            );
          },
        ),

        // Main List
        Expanded(
          child: BlocBuilder<PenaltiesHistoryCubit, PenaltiesHistoryState>(
            builder: (context, state) {
              if (state.status == PenaltiesHistoryStatus.loading &&
                  state.items.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              if (state.status == PenaltiesHistoryStatus.failure &&
                  state.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48.r,
                        color: AppColors.errorColor,
                      ),
                      SizedBox(height: 12.h),
                      Text(s.commonError, style: AppTextStyles.w600_16),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: () => context
                            .read<PenaltiesHistoryCubit>()
                            .fetchInitialPenalties(),
                        child: Text(s.commonRetry),
                      ),
                    ],
                  ),
                );
              }

              final displayedItems = state.filterStatus == null
                  ? state.items
                  : state.items
                        .where((p) => p.status == state.filterStatus)
                        .toList();

              if (displayedItems.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () =>
                      context.read<PenaltiesHistoryCubit>().refresh(),
                  color: AppColors.primaryColor,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 80.h),
                      Center(
                        child: Text(
                          s.moderationNoPenalties,
                          style: AppTextStyles.w600_16.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () =>
                    context.read<PenaltiesHistoryCubit>().refresh(),
                color: AppColors.primaryColor,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  itemCount: displayedItems.length + 1,
                  itemBuilder: (context, index) {
                    if (index < displayedItems.length) {
                      final item = displayedItems[index];
                      return PenaltyCard(
                        penalty: item,
                        onAppealTap: () async {
                          final appealed = await SubmitAppealBottomSheet.show(
                            context,
                            item,
                          );
                          if (appealed == true && context.mounted) {
                            context.read<PenaltiesHistoryCubit>().refresh();
                            widget.onRefreshOverview();
                          }
                        },
                      );
                    }

                    if (state.isLoadingMore) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      );
                    }

                    return SizedBox(height: 24.h);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.borderColor,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.w600_12.copyWith(
            color: isSelected ? Colors.white : AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}
