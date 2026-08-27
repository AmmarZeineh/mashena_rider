import 'package:mashena_rider/core/base/base_cubit.dart';
import 'package:mashena_rider/features/pool/domain/entities/join_pool_params.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_suggestion_params.dart';
import 'package:mashena_rider/features/pool/domain/usecases/get_pool_suggestions_usecase.dart';
import 'package:mashena_rider/features/pool/domain/usecases/join_pool_room_usecase.dart';
import 'package:mashena_rider/features/pool/presentation/models/pool_discovery_args.dart';
import 'pool_discovery_state.dart';

class PoolDiscoveryCubit extends BaseCubit<PoolDiscoveryState> {
  final GetPoolSuggestionsUsecase _getPoolSuggestionsUsecase;
  final JoinPoolRoomUsecase _joinPoolRoomUsecase;
  final PoolDiscoveryArgs args;

  PoolDiscoveryCubit({
    required GetPoolSuggestionsUsecase getPoolSuggestionsUsecase,
    required JoinPoolRoomUsecase joinPoolRoomUsecase,
    required this.args,
  }) : _getPoolSuggestionsUsecase = getPoolSuggestionsUsecase,
       _joinPoolRoomUsecase = joinPoolRoomUsecase,
       super(const PoolDiscoveryState());

  Future<void> fetchSuggestions() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final params = PoolSuggestionParams(
      pickupLat: args.pickup.latitude,
      pickupLng: args.pickup.longitude,
      destinationLat: args.destination.latitude,
      destinationLng: args.destination.longitude,
      departureTime: args.departureTime,
    );

    final result = await _getPoolSuggestionsUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: failure.rawMessage ?? failure.code.name,
        ),
      ),
      (rooms) => emit(state.copyWith(isLoading: false, rooms: rooms)),
    );
  }

  Future<void> joinRoom({required int roomId, int seatsNeeded = 1}) async {
    emit(state.copyWith(isJoining: true, clearError: true));

    final params = JoinPoolParams(
      pickupLat: args.pickup.latitude,
      pickupLng: args.pickup.longitude,
      pickupAddress: args.pickup.name,
      seatsNeeded: seatsNeeded,
    );

    final result = await _joinPoolRoomUsecase(roomId, params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isJoining: false,
          errorMessage: failure.rawMessage ?? failure.code.name,
        ),
      ),
      (room) => emit(state.copyWith(isJoining: false, joinedRoom: room)),
    );
  }
}
