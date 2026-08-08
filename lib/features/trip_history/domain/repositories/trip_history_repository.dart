import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/trip_history/domain/entities/rider_trip_status.dart';
import 'package:mashena_rider/features/trip_history/domain/entities/trip_history_item.dart';

abstract class TripHistoryRepository {
  Future<Either<Failure, List<TripHistoryItem>>> getRiderTripHistory({
    int skip = 0,
    int limit = 10,
    RiderTripStatus? status,
  });
}
