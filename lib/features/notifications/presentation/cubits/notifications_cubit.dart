import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/constants/app_pagination.dart';
import 'package:mashena_rider/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:mashena_rider/features/notifications/presentation/cubits/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsCubit(this._repository) : super(const NotificationsState());

  /// Initial load of notifications (page 1, skip = 0)
  Future<void> fetchInitialNotifications() async {
    emit(
      state.copyWith(
        status: NotificationsStatus.loading,
        failure: null,
        clearLoadMoreFailure: true,
      ),
    );

    final result = await _repository.getNotifications(
      skip: 0,
      limit: AppPagination.defaultPageSize,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: NotificationsStatus.failure, failure: failure),
      ),
      (data) => emit(
        state.copyWith(
          status: NotificationsStatus.success,
          items: data.items,
          totalCount: data.count,
          unreadCount: data.unreadCount,
          page: 1,
          hasMore: data.items.length >= AppPagination.defaultPageSize,
        ),
      ),
    );
  }

  /// Paginated load for subsequent pages (skip = current items length)
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true, clearLoadMoreFailure: true));

    final currentSkip = state.items.length;
    final result = await _repository.getNotifications(
      skip: currentSkip,
      limit: AppPagination.defaultPageSize,
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingMore: false, loadMoreFailure: failure)),
      (data) {
        final hasMorePages = data.items.length >= AppPagination.defaultPageSize;
        emit(
          state.copyWith(
            items: [...state.items, ...data.items],
            totalCount: data.count,
            unreadCount: data.unreadCount,
            page: state.page + 1,
            hasMore: hasMorePages,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  /// Refresh notifications list back to page 1
  Future<void> refresh() async {
    await fetchInitialNotifications();
  }
}
