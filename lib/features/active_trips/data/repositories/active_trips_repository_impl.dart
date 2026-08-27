import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/network/api_exception.dart';
import 'package:mashena_rider/core/network/api_failure_mapper.dart';
import '../../domain/entities/active_trip_context.dart';
import '../../domain/repositories/active_trips_repository.dart';
import '../datasources/active_trips_remote_data_source.dart';

class ActiveTripsRepositoryImpl implements ActiveTripsRepository {
  final ActiveTripsRemoteDataSource _remoteDataSource;

  const ActiveTripsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ActiveTripContext>>> getActiveTrips() async {
    try {
      final models = await _remoteDataSource.getActiveTrips();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }
}
