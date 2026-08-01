import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/features/home/domain/repositories/ride_repository.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/location_cubit/location_cubit.dart';

class HomeCubit extends Cubit<void> {
  HomeCubit(this._rideRepository, this._locationCubit) : super(null);

  final RideRepository _rideRepository;
  final LocationCubit _locationCubit;

  /// Called once when the home screen mounts.
  Future<void> init() async {
    // Connect socket early so the rider is registered before any ride is submitted.
    _rideRepository.connectSocket();
    await _locationCubit.init();
  }
}
