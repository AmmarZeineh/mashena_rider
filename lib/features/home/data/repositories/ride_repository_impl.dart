import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import 'package:mashena_rider/core/network/api_exception.dart';
import 'package:mashena_rider/core/network/api_failure_mapper.dart';
import 'package:mashena_rider/features/home/data/datasources/ride_socket_data_source.dart';
import 'package:mashena_rider/features/home/data/models/ride_estimate_response_model.dart';
import 'package:mashena_rider/features/home/data/models/ride_submission_response_model.dart';
import 'package:mashena_rider/features/home/data/models/matched_trip_model.dart';
import 'package:mashena_rider/features/home/data/mappers/matched_trip_mapper.dart';
import 'package:mashena_rider/features/home/data/mappers/ride_estimate_response_mapper.dart';
import 'package:mashena_rider/features/home/data/mappers/ride_submission_response_mapper.dart';
import 'package:mashena_rider/features/home/data/mappers/trip_cancelled_mapper.dart';
import 'package:mashena_rider/features/home/data/mappers/trip_completed_mapper.dart';
import 'package:mashena_rider/features/home/domain/entities/driver_arrived.dart';
import 'package:mashena_rider/features/home/data/mappers/driver_arrived_mapper.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';
import 'package:mashena_rider/features/home/domain/entities/matched_trip.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_completed.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_cancelled.dart';
import 'package:mashena_rider/features/home/data/models/trip_share_model.dart';
import 'package:mashena_rider/features/home/data/models/trip_wallet_payment_model.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_share.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_wallet_payment_entity.dart';
import '../../domain/entities/ride_request.dart';
import '../../domain/repositories/ride_repository.dart';
import '../models/ride_request_model.dart';

class RideRepositoryImpl implements RideRepository {
  final ApiClient _apiClient;
  final RideSocketDataSource _rideSocketDataSource;

  RideRepositoryImpl(this._apiClient, this._rideSocketDataSource);

  @override
  Future<Either<Failure, MatchedTrip>> getMatchedTripDetails(
    int rideRequestId,
  ) async {
    try {
      final response = await _apiClient.get(
        '${BackendEndpoints.getMatchedTrip}/$rideRequestId',
      );

      if (response is! Map) {
        return const Left(
          Failure(
            FailureCode.unknown,
            rawMessage: 'Invalid matched trip details response',
          ),
        );
      }

      final jsonMap = Map<String, dynamic>.from(response);
      final data = (jsonMap['data'] is Map<String, dynamic>)
          ? jsonMap['data'] as Map<String, dynamic>
          : jsonMap;

      final matchedTrip = MatchedTripModel.fromJson(data).toEntity();

      return Right(matchedTrip);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RideEstimateResponse>> createRideRequest(
    RideRequest request,
  ) async {
    try {
      final model = RideRequestModel.fromEntity(request);
      final response = await _apiClient.post(
        BackendEndpoints.createRideRequest,
        body: model.toJson(),
      );

      if (response is! Map) {
        return const Left(
          Failure(
            FailureCode.unknown,
            rawMessage: 'Invalid ride estimates response',
          ),
        );
      }

      final estimates = RideEstimateResponseModel.fromJson(
        Map<String, dynamic>.from(response),
      ).toEntity();
      return Right(estimates);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RideSubmissionResponse>> submitRideRequest({
    required RideRequest request,
    required int vehicleTypeId,
  }) async {
    try {
      final model = RideRequestModel.fromEntity(request);
      final body = {...model.toJson(), 'vehicleTypeId': vehicleTypeId};

      final response = await _apiClient.post(
        BackendEndpoints.submitRideRequest,
        body: body,
      );

      if (response is! Map) {
        return const Left(
          Failure(
            FailureCode.unknown,
            rawMessage: 'Invalid ride submission response',
          ),
        );
      }

      final result = RideSubmissionResponseModel.fromJson(
        Map<String, dynamic>.from(response),
      ).toEntity();

      return Right(result);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Stream<int> get rideMatchedStream => _rideSocketDataSource.rideMatchedStream;

  @override
  Stream<MapLatLng> get driverLocationStream =>
      _rideSocketDataSource.driverLocationStream;

  @override
  Stream<DriverArrived> get driverArrivedStream => _rideSocketDataSource
      .driverArrivedStream
      .map((payload) => payload.toEntity());

  @override
  Stream<int> get driverStartedStream =>
      _rideSocketDataSource.driverStartedStream;

  @override
  Stream<TripCompleted> get tripCompletedStream => _rideSocketDataSource
      .tripCompletedStream
      .map((payload) => payload.toEntity());

  @override
  Stream<TripCancelled> get tripCancelledStream => _rideSocketDataSource
      .tripCancelledStream
      .map((payload) => payload.toEntity());

  @override
  Stream<int> get rideExpiredStream => _rideSocketDataSource.rideExpiredStream;

  @override
  Stream<bool> get connectionStatusStream =>
      _rideSocketDataSource.connectionStatusStream;

  @override
  Future<void> connectSocket() => _rideSocketDataSource.connectSocket();

  @override
  void listenToRide(int rideRequestId) {
    _rideSocketDataSource.listenToRide(rideRequestId);
  }

  @override
  void stopListeningToRide(int rideRequestId) {
    _rideSocketDataSource.stopListeningToRide(rideRequestId);
  }

  @override
  Future<Either<Failure, void>> cancelRide(int rideRequestId) async {
    try {
      await _apiClient.post(
        '${BackendEndpoints.cancelRideByRider}/$rideRequestId/cancel-by-rider',
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TripShare>> shareTrip(int rideRequestId) async {
    try {
      final response = await _apiClient.post(
        BackendEndpoints.shareTripByRide(rideRequestId),
      );

      if (response is! Map) {
        return const Left(
          Failure(
            FailureCode.unknown,
            rawMessage: 'Invalid share trip response',
          ),
        );
      }

      final model = TripShareModel.fromJson(
        Map<String, dynamic>.from(response),
      );

      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> revokeShareTrip(int rideRequestId) async {
    try {
      await _apiClient.delete(BackendEndpoints.shareTripByRide(rideRequestId));
      return const Right(true);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TripWalletPaymentEntity>> payTripWithWallet(
    int rideRequestId,
  ) async {
    try {
      final response = await _apiClient.post(
        BackendEndpoints.payTripByRide(rideRequestId),
      );

      if (response is! Map) {
        return const Left(
          Failure(FailureCode.unknown, rawMessage: 'Invalid payment response'),
        );
      }

      final jsonMap = Map<String, dynamic>.from(response);
      final data = (jsonMap['data'] is Map<String, dynamic>)
          ? jsonMap['data'] as Map<String, dynamic>
          : jsonMap;

      final model = TripWalletPaymentModel.fromJson(data);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }
}
