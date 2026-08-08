import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import 'package:mashena_rider/core/network/api_exception.dart';
import 'package:mashena_rider/core/network/api_failure_mapper.dart';
import 'package:mashena_rider/features/trip_history/data/models/trip_history_item_model.dart';
import 'package:mashena_rider/features/trip_history/domain/entities/rider_trip_status.dart';
import 'package:mashena_rider/features/trip_history/domain/entities/trip_history_item.dart';
import 'package:mashena_rider/features/trip_history/domain/repositories/trip_history_repository.dart';

class TripHistoryRepositoryImpl implements TripHistoryRepository {
  final ApiClient _api;

  TripHistoryRepositoryImpl(this._api);

  @override
  Future<Either<Failure, List<TripHistoryItem>>> getRiderTripHistory({
    int skip = 0,
    int limit = 10,
    RiderTripStatus? status,
  }) async {
    try {
      final response = await _api.get(
        BackendEndpoints.riderTripHistory,
        query: {
          'skip': skip,
          'limit': limit,
          if (status != null) 'status': status.value,
        },
      );
      final map = response as Map<String, dynamic>;
      final list = (map['data'] as List? ?? [])
          .map(
            (item) => TripHistoryItemModel.fromJson(
              item as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();
      return Right(list);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }
}
