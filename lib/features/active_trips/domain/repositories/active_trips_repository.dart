import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../entities/active_trip_context.dart';

abstract interface class ActiveTripsRepository {
  /// Fetches all active trip contexts (regular trips and shared rides).
  Future<Either<Failure, List<ActiveTripContext>>> getActiveTrips();
}
