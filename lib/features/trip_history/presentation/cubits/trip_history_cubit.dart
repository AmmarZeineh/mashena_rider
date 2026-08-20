import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/constants/app_pagination.dart';
import 'package:mashena_rider/features/trip_history/domain/entities/rider_trip_status.dart';
import 'package:mashena_rider/features/trip_history/domain/repositories/trip_history_repository.dart';
import 'package:mashena_rider/features/trip_history/presentation/cubits/trip_history_state.dart';

class TripHistoryCubit extends Cubit<TripHistoryState> {
  final TripHistoryRepository _repository;

  TripHistoryCubit(this._repository) : super(const TripHistoryState());

  /// Initial load of trip history items for page 1
  Future<void> fetchInitialTrips({RiderTripStatus? status}) async {
    final targetStatus = status ?? state.selectedStatusFilter;

    emit(
      state.copyWith(
        status: TripHistoryStatus.loading,
        failure: null,
        clearLoadMoreFailure: true,
      ),
    );

    final result = await _repository.getRiderTripHistory(
      skip: 0,
      limit: AppPagination.defaultPageSize,
      status: targetStatus,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: TripHistoryStatus.failure, failure: failure),
      ),
      (newItems) => emit(
        state.copyWith(
          status: TripHistoryStatus.success,
          items: newItems,
          page: 1,
          hasMore: newItems.length >= AppPagination.defaultPageSize,
        ),
      ),
    );
  }

  /// Paginated load for subsequent pages (skip = current items length)
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true, clearLoadMoreFailure: true));

    final currentSkip = state.items.length;
    final result = await _repository.getRiderTripHistory(
      skip: currentSkip,
      limit: AppPagination.defaultPageSize,
      status: state.selectedStatusFilter,
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingMore: false, loadMoreFailure: failure)),
      (newItems) {
        final hasMorePages = newItems.length >= AppPagination.defaultPageSize;
        emit(
          state.copyWith(
            items: [...state.items, ...newItems],
            page: state.page + 1,
            hasMore: hasMorePages,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  /// Select status filter tab (All, Completed, Canceled, etc.)
  Future<void> selectStatusFilter(RiderTripStatus? status) async {
    if (state.selectedStatusFilter == status &&
        state.status == TripHistoryStatus.success) {
      return;
    }

    if (status == null) {
      emit(state.copyWith(clearStatusFilter: true, items: []));
    } else {
      emit(state.copyWith(selectedStatusFilter: status, items: []));
    }

    await fetchInitialTrips();
  }

  /// Refresh trip history back to page 1
  Future<void> refresh() async {
    await fetchInitialTrips();
  }
}
