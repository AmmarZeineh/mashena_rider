import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/moderation/domain/entities/appeal_entity.dart';

enum AppealsHistoryStatus { initial, loading, success, failure }

class AppealsHistoryState extends Equatable {
  final AppealsHistoryStatus status;
  final List<AppealEntity> items;
  final Failure? failure;
  final Failure? loadMoreFailure;
  final bool hasMore;
  final bool isLoadingMore;

  const AppealsHistoryState({
    this.status = AppealsHistoryStatus.initial,
    this.items = const [],
    this.failure,
    this.loadMoreFailure,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  AppealsHistoryState copyWith({
    AppealsHistoryStatus? status,
    List<AppealEntity>? items,
    Failure? failure,
    Failure? loadMoreFailure,
    bool clearLoadMoreFailure = false,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return AppealsHistoryState(
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
