import 'package:mashena_rider/core/base/base_cubit.dart';
import 'package:mashena_rider/core/constants/app_pagination.dart';
import '../../../domain/usecases/get_my_wallet_transactions_usecase.dart';
import 'wallet_transactions_state.dart';

class WalletTransactionsCubit extends BaseCubit<WalletTransactionsState> {
  final GetMyWalletTransactionsUsecase _usecase;

  WalletTransactionsCubit(this._usecase)
    : super(const WalletTransactionsState());

  Future<void> fetchInitialTransactions() async {
    emit(
      state.copyWith(
        status: WalletTransactionsStatus.loading,
        failure: null,
        clearLoadMoreFailure: true,
      ),
    );

    final result = await _usecase(
      skip: 0,
      limit: AppPagination.defaultPageSize,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WalletTransactionsStatus.failure,
          failure: failure,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: WalletTransactionsStatus.success,
          items: response.data,
          totalCount: response.count,
          page: 1,
          hasMore: response.data.length >= AppPagination.defaultPageSize,
        ),
      ),
    );
  }

  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true, clearLoadMoreFailure: true));

    final currentSkip = state.items.length;
    final result = await _usecase(
      skip: currentSkip,
      limit: AppPagination.defaultPageSize,
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingMore: false, loadMoreFailure: failure)),
      (response) {
        final hasMorePages =
            response.data.length >= AppPagination.defaultPageSize;
        emit(
          state.copyWith(
            items: [...state.items, ...response.data],
            totalCount: response.count,
            isLoadingMore: false,
            hasMore: hasMorePages,
            page: state.page + 1,
          ),
        );
      },
    );
  }

  Future<void> refreshTransactions() async {
    final result = await _usecase(
      skip: 0,
      limit: AppPagination.defaultPageSize,
    );

    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (response) => emit(
        state.copyWith(
          status: WalletTransactionsStatus.success,
          items: response.data,
          totalCount: response.count,
          page: 1,
          hasMore: response.data.length >= AppPagination.defaultPageSize,
        ),
      ),
    );
  }
}
