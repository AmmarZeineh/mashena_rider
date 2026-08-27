import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../../../domain/entities/wallet_transaction_entity.dart';

enum WalletTransactionsStatus { initial, loading, success, failure }

class WalletTransactionsState extends Equatable {
  final WalletTransactionsStatus status;
  final List<WalletTransactionEntity> items;
  final int totalCount;
  final Failure? failure;
  final bool isLoadingMore;
  final bool hasMore;
  final Failure? loadMoreFailure;
  final int page;

  const WalletTransactionsState({
    this.status = WalletTransactionsStatus.initial,
    this.items = const [],
    this.totalCount = 0,
    this.failure,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.loadMoreFailure,
    this.page = 1,
  });

  bool get isLoading => status == WalletTransactionsStatus.loading;
  bool get isSuccess => status == WalletTransactionsStatus.success;
  bool get isFailure => status == WalletTransactionsStatus.failure;
  bool get isEmpty => isSuccess && items.isEmpty;

  WalletTransactionsState copyWith({
    WalletTransactionsStatus? status,
    List<WalletTransactionEntity>? items,
    int? totalCount,
    Failure? failure,
    bool? isLoadingMore,
    bool? hasMore,
    Failure? loadMoreFailure,
    int? page,
    bool clearLoadMoreFailure = false,
  }) {
    return WalletTransactionsState(
      status: status ?? this.status,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      failure: failure ?? this.failure,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      loadMoreFailure: clearLoadMoreFailure
          ? null
          : (loadMoreFailure ?? this.loadMoreFailure),
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    totalCount,
    failure,
    isLoadingMore,
    hasMore,
    loadMoreFailure,
    page,
  ];
}
