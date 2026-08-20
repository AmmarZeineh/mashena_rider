import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/notifications/domain/entities/notification_item.dart';

enum NotificationsStatus { initial, loading, success, failure }

class NotificationsState extends Equatable {
  final NotificationsStatus status;
  final List<NotificationItem> items;
  final int totalCount;
  final int unreadCount;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final Failure? failure;
  final Failure? loadMoreFailure;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.items = const [],
    this.totalCount = 0,
    this.unreadCount = 0,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 1,
    this.failure,
    this.loadMoreFailure,
  });

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationItem>? items,
    int? totalCount,
    int? unreadCount,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    Failure? failure,
    Failure? loadMoreFailure,
    bool clearLoadMoreFailure = false,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
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
    totalCount,
    unreadCount,
    isLoadingMore,
    hasMore,
    page,
    failure,
    loadMoreFailure,
  ];
}
