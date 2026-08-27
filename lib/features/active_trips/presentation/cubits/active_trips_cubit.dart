import '../../../../core/base/base_cubit.dart';
import '../../domain/usecases/get_active_trips_usecase.dart';
import 'active_trips_state.dart';

class ActiveTripsCubit extends BaseCubit<ActiveTripsState> {
  final GetActiveTripsUsecase _getActiveTripsUsecase;

  ActiveTripsCubit(this._getActiveTripsUsecase)
      : super(const ActiveTripsState());

  Future<void> fetchActiveTrips({bool isRefresh = false}) async {
    if (isRefresh) {
      emit(state.copyWith(isRefreshing: true, clearFailure: true));
    } else {
      emit(state.copyWith(
        status: ActiveTripsStatus.loading,
        clearFailure: true,
      ));
    }

    final result = await _getActiveTripsUsecase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: ActiveTripsStatus.failure,
        isRefreshing: false,
        failure: failure,
      )),
      (trips) => emit(state.copyWith(
        status: ActiveTripsStatus.success,
        isRefreshing: false,
        trips: trips,
      )),
    );
  }

  Future<void> refresh() => fetchActiveTrips(isRefresh: true);
}
