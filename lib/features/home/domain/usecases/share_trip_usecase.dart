import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_share.dart';
import '../repositories/ride_repository.dart';

class ShareTripUsecase {
  final RideRepository _repository;

  ShareTripUsecase(this._repository);

  Future<Either<Failure, TripShare>> call(int rideRequestId) {
    return _repository.shareTrip(rideRequestId);
  }
}
