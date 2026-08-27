import 'package:mashena_rider/core/base/base_cubit.dart';
import 'package:mashena_rider/features/coupons/domain/repositories/coupons_repository.dart';
import 'package:mashena_rider/features/coupons/presentation/cubits/coupons_state.dart';

class CouponsCubit extends BaseCubit<CouponsState> {
  final CouponsRepository repository;

  CouponsCubit(this.repository) : super(const CouponsState());

  Future<void> fetchAllData() async {
    emit(state.copyWith(status: CouponsStatus.loading));

    final couponsResult = await repository.getMyCoupons();
    final historyResult = await repository.getMyHistory();

    couponsResult.fold(
      (failure) =>
          emit(state.copyWith(status: CouponsStatus.error, failure: failure)),
      (activeCoupons) {
        historyResult.fold(
          (failure) => emit(
            state.copyWith(
              status: CouponsStatus.loaded,
              activeCoupons: activeCoupons,
              failure: failure,
            ),
          ),
          (historyItems) => emit(
            state.copyWith(
              status: CouponsStatus.loaded,
              activeCoupons: activeCoupons,
              historyItems: historyItems,
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchActiveCoupons() async {
    final result = await repository.getMyCoupons();
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (activeCoupons) => emit(state.copyWith(activeCoupons: activeCoupons)),
    );
  }

  Future<void> fetchHistory() async {
    final result = await repository.getMyHistory();
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (historyItems) => emit(state.copyWith(historyItems: historyItems)),
    );
  }

  Future<void> activateCoupon(String code) async {
    emit(state.copyWith(activationStatus: ActivationStatus.loading));

    final result = await repository.activateCoupon(code);
    result.fold(
      (failure) => emit(
        state.copyWith(
          activationStatus: ActivationStatus.error,
          activationFailure: failure,
        ),
      ),
      (activatedCoupon) async {
        final updatedActiveList = [activatedCoupon, ...state.activeCoupons];
        emit(
          state.copyWith(
            activationStatus: ActivationStatus.success,
            activeCoupons: updatedActiveList,
            newlyActivatedCoupon: activatedCoupon,
          ),
        );
      },
    );
  }

  void resetActivationState() {
    emit(
      state.copyWith(
        activationStatus: ActivationStatus.initial,
        newlyActivatedCoupon: null,
      ),
    );
  }
}
