import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/trip_history/domain/entities/rider_trip_status.dart';
import 'package:mashena_rider/features/trip_history/domain/entities/trip_history_item.dart';

enum TripHistoryStatus { initial, loading, success, failure }

class TripHistoryState extends Equatable {
  final TripHistoryStatus status;
  final List<TripHistoryItem> items;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final RiderTripStatus? selectedStatusFilter;
  final Failure? failure;
  final Failure? loadMoreFailure;

  const TripHistoryState({
    this.status = TripHistoryStatus.initial,
    this.items = const [],
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 1,
    this.selectedStatusFilter,
    this.failure,
    this.loadMoreFailure,
  });

  TripHistoryState copyWith({
    TripHistoryStatus? status,
    List<TripHistoryItem>? items,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    RiderTripStatus? selectedStatusFilter,
    bool clearStatusFilter = false,
    Failure? failure,
    Failure? loadMoreFailure,
    bool clearLoadMoreFailure = false,
  }) {
    return TripHistoryState(
      status: status ?? this.status,
      items: items ?? this.items,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      selectedStatusFilter: clearStatusFilter
          ? null
          : (selectedStatusFilter ?? this.selectedStatusFilter),
      failure: failure ?? this.failure,
      loadMoreFailure: clearLoadMoreFailure
          ? null
          : (loadMoreFailure ?? this.loadMoreFailure),
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        isLoadingMore,
        hasMore,
        page,
        selectedStatusFilter,
        failure,
        loadMoreFailure,
      ];
}

