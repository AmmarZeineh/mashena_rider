import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/base/base_cubit.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_share.dart';
import 'package:mashena_rider/features/home/domain/usecases/revoke_share_trip_usecase.dart';
import 'package:mashena_rider/features/home/domain/usecases/share_trip_usecase.dart';

part 'trip_share_state.dart';

class TripShareCubit extends BaseCubit<TripShareState> {
  final ShareTripUsecase _shareTripUsecase;
  final RevokeShareTripUsecase _revokeShareTripUsecase;

  TripShareCubit(this._shareTripUsecase, this._revokeShareTripUsecase)
    : super(const TripShareInitial());

  Future<void> shareTrip(int rideRequestId) async {
    emit(const TripShareLoading());
    final result = await _shareTripUsecase(rideRequestId);
    result.fold(
      (failure) =>
          emit(TripShareError(failure.rawMessage ?? failure.code.name)),
      (tripShare) => emit(TripShareLoaded(tripShare)),
    );
  }

  Future<void> revokeShareTrip(int rideRequestId) async {
    final currentState = state;
    if (currentState is TripShareLoaded) {
      emit(TripShareRevoking(currentState.tripShare));
    } else {
      emit(const TripShareLoading());
    }

    final result = await _revokeShareTripUsecase(rideRequestId);
    result.fold(
      (failure) =>
          emit(TripShareError(failure.rawMessage ?? failure.code.name)),
      (_) => emit(const TripShareInitial()),
    );
  }

  void reset() {
    emit(const TripShareInitial());
  }
}
