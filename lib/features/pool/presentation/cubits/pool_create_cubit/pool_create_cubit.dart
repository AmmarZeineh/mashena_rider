import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/features/pool/domain/entities/create_pool_params.dart';
import 'package:mashena_rider/features/pool/domain/usecases/create_pool_room_usecase.dart';
import 'package:mashena_rider/features/pool/presentation/models/pool_discovery_args.dart';
import 'pool_create_state.dart';

class PoolCreateCubit extends Cubit<PoolCreateState> {
  final CreatePoolRoomUsecase _createPoolRoomUsecase;
  final PoolDiscoveryArgs args;

  PoolCreateCubit({
    required CreatePoolRoomUsecase createPoolRoomUsecase,
    required this.args,
  }) : _createPoolRoomUsecase = createPoolRoomUsecase,
       super(
         PoolCreateState(
           departureTime:
               args.departureTime ??
               DateTime.now().add(const Duration(minutes: 15)),
         ),
       );

  void setDepartureTime(DateTime time) {
    emit(state.copyWith(departureTime: time));
  }

  void setMaxPassengers(int count) {
    final clampedCount = count.clamp(2, 6);
    final clampedSeats = state.seatsNeeded > clampedCount
        ? clampedCount
        : state.seatsNeeded;
    emit(
      state.copyWith(maxPassengers: clampedCount, seatsNeeded: clampedSeats),
    );
  }

  void setSeatsNeeded(int count) {
    final clampedSeats = count.clamp(1, state.maxPassengers);
    emit(state.copyWith(seatsNeeded: clampedSeats));
  }

  Future<void> submitCreatePool() async {
    emit(state.copyWith(isSubmitting: true, clearError: true));

    final params = CreatePoolParams(
      pickupLat: args.pickup.latitude,
      pickupLng: args.pickup.longitude,
      pickupAddress: args.pickup.name,
      destinationLat: args.destination.latitude,
      destinationLng: args.destination.longitude,
      destinationAddress: args.destination.name,
      departureTime: state.departureTime,
      maxPassengers: state.maxPassengers,
      seatsNeeded: state.seatsNeeded,
    );

    final result = await _createPoolRoomUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: failure.rawMessage ?? failure.code.name,
        ),
      ),
      (room) => emit(state.copyWith(isSubmitting: false, createdRoom: room)),
    );
  }
}
