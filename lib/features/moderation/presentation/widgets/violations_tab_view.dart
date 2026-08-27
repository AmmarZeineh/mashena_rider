import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/constants/app_pagination.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/violations_history_cubit/violations_history_cubit.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/violations_history_cubit/violations_history_state.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/violation_card.dart';

class ViolationsTabView extends StatefulWidget {
  const ViolationsTabView({super.key});

  @override
  State<ViolationsTabView> createState() => _ViolationsTabViewState();
}

class _ViolationsTabViewState extends State<ViolationsTabView> {
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
      context.read<ViolationsHistoryCubit>().loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocBuilder<ViolationsHistoryCubit, ViolationsHistoryState>(
      builder: (context, state) {
        if (state.status == ViolationsHistoryStatus.loading &&
            state.items.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (state.status == ViolationsHistoryStatus.failure &&
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
                  onPressed: () => context
                      .read<ViolationsHistoryCubit>()
                      .fetchInitialViolations(),
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
            onRefresh: () =>
                context.read<ViolationsHistoryCubit>().refresh(),
            color: AppColors.primaryColor,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 80.h),
                Center(
                  child: Text(
                    s.moderationNoViolations,
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
          onRefresh: () =>
              context.read<ViolationsHistoryCubit>().refresh(),
          color: AppColors.primaryColor,
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            itemCount: state.items.length + 1,
            itemBuilder: (context, index) {
              if (index < state.items.length) {
                return ViolationCard(violation: state.items[index]);
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
