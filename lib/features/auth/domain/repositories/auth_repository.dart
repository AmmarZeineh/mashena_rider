import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/auth/data/models/login_response.dart';
import 'package:mashena_rider/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signup({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  });

  Future<Either<Failure, LoginResponseDto>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> sendOtp({
    required String channel,
    String? email,
    String? phone,
  });
}
