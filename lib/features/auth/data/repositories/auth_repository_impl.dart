import 'package:dartz/dartz.dart';

import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/network/api_exception.dart';
import 'package:mashena_rider/core/network/api_failure_mapper.dart';
import 'package:mashena_rider/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:mashena_rider/features/auth/data/mappers/login_user_mapper.dart';
import 'package:mashena_rider/features/auth/data/mappers/user_mapper.dart';
import 'package:mashena_rider/features/auth/data/models/login_request_dto.dart';
import 'package:mashena_rider/features/auth/data/models/send_otp_request_dto.dart';
import 'package:mashena_rider/features/auth/data/models/signup_request_dto.dart';
import 'package:mashena_rider/features/auth/data/models/verify_otp_request_dto.dart';

import 'package:mashena_rider/features/auth/domain/entities/auth_session.dart';
import 'package:mashena_rider/features/auth/domain/entities/user.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._local);
  final AuthLocalDataSource _local;

  final AuthRemoteDataSource _remote;

  @override
  Future<Either<Failure, User>> signup({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      final dto = await _remote.signup(
        SignupRequestDto(
          email: email,
          password: password,
          fullName: fullName,
          phoneNumber: phoneNumber,
        ),
      );

      return Right(dto.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
    required String? fcmToken,
  }) async {
    try {
      final dto = await _remote.login(
        LoginRequestDto(email: email, password: password, fcmToken: fcmToken),
      );
      await _local.cacheSession(accessToken: dto.accessToken, user: dto.user);
      return Right(
        AuthSession(accessToken: dto.accessToken, user: dto.user.toEntity()),
      );
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendOtp({String? email, String? phone}) async {
    try {
      await _remote.sendOtp(SendOtpRequestDto(email: email, phone: phone));
      return const Right(unit);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyOtp({
    required String code,
    String? email,
    String? phone,
  }) async {
    try {
      await _remote.verifyOtp(
        VerifyOtpRequestDto(code: code, email: email, phone: null),
      );
      return const Right(unit);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> getCachedSession() async {
    try {
      final token = await _local.getCachedAccessToken();
      final userDto = await _local.getCachedUser();

      if (token == null || token.isEmpty || userDto == null) {
        return Left(Failure(FailureCode.unauthorized));
      }

      return Right(AuthSession(accessToken: token, user: userDto.toEntity()));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _local.clearSession();
      return const Right(unit);
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }
}
