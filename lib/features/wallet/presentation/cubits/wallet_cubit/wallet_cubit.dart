import 'package:mashena_rider/core/base/base_cubit.dart';
import '../../../domain/usecases/get_my_wallet_usecase.dart';
import 'wallet_state.dart';

class WalletCubit extends BaseCubit<WalletState> {
  final GetMyWalletUsecase _getMyWalletUsecase;

  WalletCubit(this._getMyWalletUsecase) : super(const WalletState());

  Future<void> fetchWallet() async {
    if (state.status == WalletStatus.loading && !state.isRefreshing) return;

    emit(state.copyWith(status: WalletStatus.loading, failure: null));

    final result = await _getMyWalletUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WalletStatus.error,
          failure: failure,
          isRefreshing: false,
        ),
      ),
      (wallet) => emit(
        state.copyWith(
          status: WalletStatus.loaded,
          wallet: wallet,
          failure: null,
          isRefreshing: false,
        ),
      ),
    );
  }

  Future<void> refreshWallet() async {
    emit(state.copyWith(isRefreshing: true));

    final result = await _getMyWalletUsecase();

    result.fold(
      (failure) => emit(state.copyWith(failure: failure, isRefreshing: false)),
      (wallet) => emit(
        state.copyWith(
          status: WalletStatus.loaded,
          wallet: wallet,
          isRefreshing: false,
          failure: null,
        ),
      ),
    );
  }
}
