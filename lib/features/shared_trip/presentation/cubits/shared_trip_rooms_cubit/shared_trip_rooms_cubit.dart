import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/base/base_cubit.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';
import 'package:mashena_rider/features/pool/domain/entities/join_pool_params.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_room_entity.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_suggestion_params.dart';
import 'package:mashena_rider/features/pool/domain/usecases/get_pool_suggestions_usecase.dart';
import 'package:mashena_rider/features/pool/domain/usecases/join_pool_room_usecase.dart';
import '../../../domain/entities/search_shared_ride_params.dart';
import '../../../domain/entities/shared_ride_room_entity.dart';
import '../../../domain/usecases/search_shared_rides_usecase.dart';
import '../../models/shared_trip_rooms_args.dart';
import 'shared_trip_rooms_state.dart';

class SharedTripRoomsCubit extends BaseCubit<SharedTripRoomsState> {
  final SearchSharedRidesUsecase _searchSharedRidesUsecase;
  final GetPoolSuggestionsUsecase _getPoolSuggestionsUsecase;
  final JoinPoolRoomUsecase _joinPoolRoomUsecase;

  SharedTripRoomsCubit({
    required SearchSharedRidesUsecase searchSharedRidesUsecase,
    required GetPoolSuggestionsUsecase getPoolSuggestionsUsecase,
    required JoinPoolRoomUsecase joinPoolRoomUsecase,
    required SharedTripRoomsArgs args,
  }) : _searchSharedRidesUsecase = searchSharedRidesUsecase,
       _getPoolSuggestionsUsecase = getPoolSuggestionsUsecase,
       _joinPoolRoomUsecase = joinPoolRoomUsecase,
       super(
         SharedTripRoomsState(
           pickupPlace: args.pickup,
           destinationPlace: args.destination,
         ),
       );

  Future<void> searchRooms() async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    final sharedParams = SearchSharedRideParams(
      pickupLat: state.pickupPlace.latitude,
      pickupLng: state.pickupPlace.longitude,
      dropoffLat: state.destinationPlace.latitude,
      dropoffLng: state.destinationPlace.longitude,
      seatsNeeded: state.seatsNeeded,
      maxDistanceKm: state.maxDistanceKm,
    );

    final poolParams = PoolSuggestionParams(
      pickupLat: state.pickupPlace.latitude,
      pickupLng: state.pickupPlace.longitude,
      destinationLat: state.destinationPlace.latitude,
      destinationLng: state.destinationPlace.longitude,
    );

    final results = await Future.wait([
      _searchSharedRidesUsecase(sharedParams),
      _getPoolSuggestionsUsecase(poolParams),
    ]);

    final sharedEither =
        results[0] as Either<Failure, List<SharedRideRoomEntity>>;
    final poolEither = results[1] as Either<Failure, List<PoolRoomEntity>>;

    List<SharedRideRoomEntity> sharedRooms = [];
    List<PoolRoomEntity> poolRooms = [];
    String? sharedError;
    String? poolError;

    sharedEither.fold(
      (failure) => sharedError = failure.rawMessage ?? failure.code.name,
      (rooms) => sharedRooms = rooms,
    );

    poolEither.fold(
      (failure) => poolError = failure.rawMessage ?? failure.code.name,
      (rooms) => poolRooms = rooms,
    );

    // If both failed and no results found at all, present error.
    final bothFailed = sharedError != null && poolError != null;
    final combinedError = bothFailed ? (sharedError ?? poolError) : null;

    emit(
      state.copyWith(
        isLoading: false,
        sharedRooms: sharedRooms,
        poolRooms: poolRooms,
        errorMessage: () => combinedError,
      ),
    );
  }

  Future<void> joinPoolRoom({required int roomId, int? seatsNeeded}) async {
    emit(state.copyWith(isJoiningPool: true, errorMessage: () => null));

    final params = JoinPoolParams(
      pickupLat: state.pickupPlace.latitude,
      pickupLng: state.pickupPlace.longitude,
      pickupAddress: state.pickupPlace.name,
      seatsNeeded: seatsNeeded ?? state.seatsNeeded,
    );

    final result = await _joinPoolRoomUsecase(roomId, params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isJoiningPool: false,
          errorMessage: () => failure.rawMessage ?? failure.code.name,
        ),
      ),
      (room) => emit(
        state.copyWith(isJoiningPool: false, joinedPoolRoom: () => room),
      ),
    );
  }

  void setFilter(UnifiedRideFilter filter) {
    emit(state.copyWith(activeFilter: filter));
  }

  void updateLocations({
    required PlaceEntity pickup,
    required PlaceEntity destination,
  }) {
    emit(state.copyWith(pickupPlace: pickup, destinationPlace: destination));
    searchRooms();
  }

  void updateFilters({int? seatsNeeded, double? maxDistanceKm}) {
    emit(
      state.copyWith(
        seatsNeeded: seatsNeeded ?? state.seatsNeeded,
        maxDistanceKm: maxDistanceKm ?? state.maxDistanceKm,
      ),
    );
    searchRooms();
  }
}
