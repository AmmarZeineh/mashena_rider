import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import 'package:mashena_rider/core/network/api_exception.dart';
import 'package:mashena_rider/core/network/api_failure_mapper.dart';
import 'package:mashena_rider/features/profile/data/models/rider_profile_model.dart';
import 'package:mashena_rider/features/profile/data/mappers/rider_profile_mapper.dart';
import 'package:mashena_rider/features/profile/domain/entities/rider_profile.dart';
import 'package:mashena_rider/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient api;

  ProfileRepositoryImpl(this.api);

  @override
  Future<Either<Failure, RiderProfile>> getProfile(int id) async {
    try {
      final response = await api.get(BackendEndpoints.riderProfile(id));
      final model = RiderProfileModel.fromJson(
        response as Map<String, dynamic>,
      );
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }
}
