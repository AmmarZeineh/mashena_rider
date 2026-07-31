import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/profile/domain/entities/rider_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, RiderProfile>> getProfile(int id);
}
