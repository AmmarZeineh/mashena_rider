import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import '../../domain/entities/ride_request.dart';
import '../../domain/repositories/ride_repository.dart';
import '../models/ride_request_model.dart';

class RideRepositoryImpl implements RideRepository {
  final ApiClient _apiClient;

  RideRepositoryImpl(this._apiClient);

  @override
  Future<Either<String, dynamic>> createRideRequest(RideRequest request) async {
    try {
      final model = RideRequestModel.fromEntity(request);
      final response = await _apiClient.post(
        '/api/ride-requests',
        body: model.toJson(),
      );
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
