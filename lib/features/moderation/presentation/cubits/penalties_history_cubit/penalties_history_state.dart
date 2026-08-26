import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_status.dart';

enum PenaltiesHistoryStatus { initial, loading, success, failure }

class PenaltiesHistoryState extends Equatable {
  final PenaltiesHistoryStatus status;
  final List<PenaltyEntity> items;
  final PenaltyStatus? filterStatus;
  final Failure? failure;
  final Failure? loadMoreFailure;
  final bool hasMore;
  final bool isLoadingMore;

  const PenaltiesHistoryState({
    this.status = PenaltiesHistoryStatus.initial,
    this.items = const [],
    this.filterStatus,
    this.failure,
    this.loadMoreFailure,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  PenaltiesHistoryState copyWith({
    PenaltiesHistoryStatus? status,
    List<PenaltyEntity>? items,
    PenaltyStatus? filterStatus,
    bool clearFilter = false,
    Failure? failure,
    Failure? loadMoreFailure,
    bool clearLoadMoreFailure = false,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PenaltiesHistoryState(
      status: status ?? this.status,
      items: items ?? this.items,
      filterStatus: clearFilter ? null : (filterStatus ?? this.filterStatus),
      failure: failure,
      loadMoreFailure: clearLoadMoreFailure
          ? null
          : (loadMoreFailure ?? this.loadMoreFailure),
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    filterStatus,
    failure,
    loadMoreFailure,
    hasMore,
    isLoadingMore,
  ];
}
