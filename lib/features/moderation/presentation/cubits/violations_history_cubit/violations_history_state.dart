import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/moderation/domain/entities/violation_entity.dart';

enum ViolationsHistoryStatus { initial, loading, success, failure }

class ViolationsHistoryState extends Equatable {
  final ViolationsHistoryStatus status;
  final List<ViolationEntity> items;
  final Failure? failure;
  final Failure? loadMoreFailure;
  final bool hasMore;
  final bool isLoadingMore;

  const ViolationsHistoryState({
    this.status = ViolationsHistoryStatus.initial,
    this.items = const [],
    this.failure,
    this.loadMoreFailure,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  ViolationsHistoryState copyWith({
    ViolationsHistoryStatus? status,
    List<ViolationEntity>? items,
    Failure? failure,
    Failure? loadMoreFailure,
    bool clearLoadMoreFailure = false,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ViolationsHistoryState(
      status: status ?? this.status,
      items: items ?? this.items,
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
    failure,
    loadMoreFailure,
    hasMore,
    isLoadingMore,
  ];
}
