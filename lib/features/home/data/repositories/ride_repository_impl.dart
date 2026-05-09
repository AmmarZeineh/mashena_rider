import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import 'package:mashena_rider/features/home/data/models/ride_estimate_response_model.dart';
import 'package:mashena_rider/features/home/data/models/ride_submission_response_model.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';
import '../../domain/entities/ride_request.dart';
import '../../domain/repositories/ride_repository.dart';
import '../models/ride_request_model.dart';

class RideRepositoryImpl implements RideRepository {
  final ApiClient _apiClient;

  RideRepositoryImpl(this._apiClient);

  @override
  Future<Either<String, RideEstimateResponse>> createRideRequest(
    RideRequest request,
  ) async {
    try {
      final model = RideRequestModel.fromEntity(request);
      final response = await _apiClient.post(
        BackendEndpoints.createRideRequest,
        body: model.toJson(),
      );

      if (response is! Map) {
        return const Left('Invalid ride estimates response');
      }

      final estimates = RideEstimateResponseModel.fromJson(
        Map<String, dynamic>.from(response),
      ).toEntity();
      return Right(estimates);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, RideSubmissionResponse>> submitRideRequest({
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
        return const Left('Invalid ride submission response');
      }

      final result = RideSubmissionResponseModel.fromJson(
        Map<String, dynamic>.from(response),
      ).toEntity();

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
