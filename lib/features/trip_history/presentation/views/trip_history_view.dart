import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/constants/app_pagination.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/trip_history/presentation/cubits/trip_history_cubit.dart';
import 'package:mashena_rider/features/trip_history/presentation/cubits/trip_history_state.dart';
import 'package:mashena_rider/features/trip_history/presentation/widgets/trip_history_card.dart';
import 'package:mashena_rider/features/trip_history/presentation/widgets/trip_status_filter_bar.dart';

class TripHistoryView extends StatelessWidget {
  const TripHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TripHistoryCubit>()..fetchInitialTrips(),
      child: const _TripHistoryContent(),
    );
  }
}

class _TripHistoryContent extends StatefulWidget {
  const _TripHistoryContent();

  @override
  State<_TripHistoryContent> createState() => _TripHistoryContentState();
}

class _TripHistoryContentState extends State<_TripHistoryContent> {
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

  /// Triggers loading next page when scroll position nears the bottom threshold
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= AppPagination.loadMoreThreshold) {
      context.read<TripHistoryCubit>().loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightScaffold,
      appBar: AppBar(
        title: Text(s.tripHistoryTitle, style: AppTextStyles.w600_18),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12.h),

            // Filter Tabs Bar
            BlocBuilder<TripHistoryCubit, TripHistoryState>(
              buildWhen: (p, c) =>
                  p.selectedStatusFilter != c.selectedStatusFilter,
              builder: (context, state) {
                return TripStatusFilterBar(
                  selectedStatus: state.selectedStatusFilter,
                  onStatusSelected: (status) {
                    context.read<TripHistoryCubit>().selectStatusFilter(status);
                  },
                );
              },
            ),

            SizedBox(height: 12.h),

            // Main Content List
            Expanded(
              child: BlocBuilder<TripHistoryCubit, TripHistoryState>(
                builder: (context, state) {
                  // Initial Full-Screen Loading
                  if (state.status == TripHistoryStatus.loading &&
                      state.items.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  // Initial Full-Screen Error
                  if (state.status == TripHistoryStatus.failure &&
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
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () => context
                                .read<TripHistoryCubit>()
                                .fetchInitialTrips(),
                            child: Text(s.commonRetry),
                          ),
                        ],
                      ),
                    );
                  }

                  // Empty State
                  if (state.items.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<TripHistoryCubit>().refresh(),
                      color: AppColors.primaryColor,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 100.h),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20.r),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withValues(
                                      alpha: 0.08,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.history_toggle_off_rounded,
                                    size: 56.r,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  s.noTripHistory,
                                  style: AppTextStyles.w600_16.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Success / Paginated List
                  return RefreshIndicator(
                    onRefresh: () => context.read<TripHistoryCubit>().refresh(),
                    color: AppColors.primaryColor,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      // Add +1 slot at the bottom for trailing load-more indicator or retry button
                      itemCount: state.items.length + 1,
                      itemBuilder: (context, index) {
                        // Main List Items
                        if (index < state.items.length) {
                          return TripHistoryCard(item: state.items[index]);
                        }

                        // Trailing Pagination Footer
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

                        // Trailing Pagination Error & Retry
                        if (state.loadMoreFailure != null) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Center(
                              child: TextButton.icon(
                                onPressed: () => context
                                    .read<TripHistoryCubit>()
                                    .loadNextPage(),
                                icon: const Icon(Icons.refresh, size: 18),
                                label: Text(
                                  s.commonRetry,
                                  style: AppTextStyles.w600_14.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        // End of List (No more items)
                        return SizedBox(height: 24.h);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
