import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';
import '../../../domain/entities/search_shared_ride_params.dart';
import '../../../domain/usecases/search_shared_rides_usecase.dart';
import '../../models/shared_trip_rooms_args.dart';
import 'shared_trip_rooms_state.dart';

class SharedTripRoomsCubit extends Cubit<SharedTripRoomsState> {
  final SearchSharedRidesUsecase _searchSharedRidesUsecase;

  SharedTripRoomsCubit({
    required SearchSharedRidesUsecase searchSharedRidesUsecase,
    required SharedTripRoomsArgs args,
  }) : _searchSharedRidesUsecase = searchSharedRidesUsecase,
       super(
         SharedTripRoomsState(
           pickupPlace: args.pickup,
           destinationPlace: args.destination,
         ),
       );

  Future<void> searchRooms() async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    final params = SearchSharedRideParams(
      pickupLat: state.pickupPlace.latitude,
      pickupLng: state.pickupPlace.longitude,
      dropoffLat: state.destinationPlace.latitude,
      dropoffLng: state.destinationPlace.longitude,
      seatsNeeded: state.seatsNeeded,
      maxDistanceKm: state.maxDistanceKm,
    );

    final result = await _searchSharedRidesUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: () => failure.rawMessage,
        ),
      ),
      (rooms) => emit(
        state.copyWith(
          isLoading: false,
          rooms: rooms,
          errorMessage: () => null,
        ),
      ),
    );
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
