import 'package:dartz/dartz.dart';
import 'package:mashena_rider/app/di/injector.dart';

import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/network/api_exception.dart';
import 'package:mashena_rider/core/network/api_failure_mapper.dart';
import 'package:mashena_rider/core/network/dio_client.dart';
import 'package:mashena_rider/features/auth/data/mappers/user_mapper.dart';
import 'package:mashena_rider/features/auth/data/models/login_request_dto.dart';
import 'package:mashena_rider/features/auth/data/models/login_response.dart';
import 'package:mashena_rider/features/auth/data/models/signup_request_dto.dart';

import 'package:mashena_rider/features/auth/domain/entities/user.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, User>> signup({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      final dto = await remote.signup(
        SignupRequestDto(
          email: email,
          password: password,
          fullName: fullName,
          phoneNumber: phoneNumber,
        ),
      );

      return Right(dto.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e, getIt.get<ApiClient>()));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResponseDto>> login({
    required String email,
    required String password,
  }) async {
    try {
      final dto = await remote.login(
        LoginRequestDto(email: email, password: password),
      );
      return Right(dto);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e, getIt.get<ApiClient>()));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }
}
