import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/constants/app_pagination.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/notifications/presentation/cubits/notifications_cubit.dart';
import 'package:mashena_rider/features/notifications/presentation/cubits/notifications_state.dart';
import 'package:mashena_rider/features/notifications/presentation/widgets/notification_card.dart';
import 'package:mashena_rider/features/notifications/presentation/widgets/notifications_empty_state.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationsCubit>()..fetchInitialNotifications(),
      child: const _NotificationsViewContent(),
    );
  }
}

class _NotificationsViewContent extends StatefulWidget {
  const _NotificationsViewContent();

  @override
  State<_NotificationsViewContent> createState() =>
      _NotificationsViewContentState();
}

class _NotificationsViewContentState extends State<_NotificationsViewContent> {
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
      context.read<NotificationsCubit>().loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightScaffold,
      appBar: AppBar(
        title: Text(s.notificationsTitle, style: AppTextStyles.w600_18),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          BlocBuilder<NotificationsCubit, NotificationsState>(
            buildWhen: (p, c) => p.unreadCount != c.unreadCount,
            builder: (context, state) {
              if (state.unreadCount <= 0) return const SizedBox.shrink();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Text(
                        s.unreadNotificationsBadge(state.unreadCount),
                        style: AppTextStyles.w600_12.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.done_all_rounded,
                      color: AppColors.primaryColor,
                    ),
                    tooltip: s.markAllAsRead,
                    onPressed: () =>
                        context.read<NotificationsCubit>().markAllAsRead(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            // Initial Full-Screen Loading
            if (state.status == NotificationsStatus.loading &&
                state.items.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            // Initial Full-Screen Error
            if (state.status == NotificationsStatus.failure &&
                state.items.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 52.r,
                        color: AppColors.errorColor,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        state.failure?.rawMessage ?? s.commonError,
                        style: AppTextStyles.w600_16,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed: () => context
                            .read<NotificationsCubit>()
                            .fetchInitialNotifications(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                        ),
                        child: Text(s.commonRetry),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Empty State
            if (state.items.isEmpty) {
              return NotificationsEmptyState(
                onRefresh: () => context.read<NotificationsCubit>().refresh(),
              );
            }

            // Success / Paginated List
            return RefreshIndicator(
              onRefresh: () => context.read<NotificationsCubit>().refresh(),
              color: AppColors.primaryColor,
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: state.items.length + 1,
                itemBuilder: (context, index) {
                  // Main List Items
                  if (index < state.items.length) {
                    return NotificationCard(item: state.items[index]);
                  }

                  // Trailing Pagination Loading Footer
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
                          onPressed: () =>
                              context.read<NotificationsCubit>().loadNextPage(),
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

                  // End of List spacing
                  return SizedBox(height: 16.h);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
