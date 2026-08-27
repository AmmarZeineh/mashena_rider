import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/constants/app_pagination.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/appeals_history_cubit/appeals_history_cubit.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/appeals_history_cubit/appeals_history_state.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/appeal_card.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/appeal_details_bottom_sheet.dart';

class AppealsTabView extends StatefulWidget {
  const AppealsTabView({super.key});

  @override
  State<AppealsTabView> createState() => _AppealsTabViewState();
}

class _AppealsTabViewState extends State<AppealsTabView> {
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
      context.read<AppealsHistoryCubit>().loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocBuilder<AppealsHistoryCubit, AppealsHistoryState>(
      builder: (context, state) {
        if (state.status == AppealsHistoryStatus.loading &&
            state.items.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (state.status == AppealsHistoryStatus.failure &&
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
                Text(
                  s.commonError,
                  style: AppTextStyles.w600_16.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 12.h),
                ElevatedButton(
                  onPressed: () =>
                      context.read<AppealsHistoryCubit>().fetchInitialAppeals(),
                  child: Text(s.commonRetry),
                ),
              ],
            ),
          );
        }

        if (state.items.isEmpty) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final emptyColor = isDark
              ? Theme.of(context).colorScheme.onSurfaceVariant
              : AppColors.textGrey;

          return RefreshIndicator(
            onRefresh: () => context.read<AppealsHistoryCubit>().refresh(),
            color: AppColors.primaryColor,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 80.h),
                Center(
                  child: Text(
                    s.moderationNoAppeals,
                    style: AppTextStyles.w600_16.copyWith(
                      color: emptyColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<AppealsHistoryCubit>().refresh(),
          color: AppColors.primaryColor,
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            itemCount: state.items.length + 1,
            itemBuilder: (context, index) {
              if (index < state.items.length) {
                final item = state.items[index];
                return AppealCard(
                  appeal: item,
                  onTap: () => AppealDetailsBottomSheet.show(context, item),
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
    );
  }
}
