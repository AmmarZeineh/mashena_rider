import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../entities/active_trip_context.dart';
import '../repositories/active_trips_repository.dart';

class GetActiveTripsUsecase {
  final ActiveTripsRepository _repository;

  const GetActiveTripsUsecase(this._repository);

  Future<Either<Failure, List<ActiveTripContext>>> call() {
    return _repository.getActiveTrips();
  }
}
