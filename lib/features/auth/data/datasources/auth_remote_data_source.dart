import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/network/dio_client.dart';
import 'package:mashena_rider/features/auth/data/models/login_request_dto.dart';
import 'package:mashena_rider/features/auth/data/models/login_response.dart';
import 'package:mashena_rider/features/auth/data/models/send_otp_request_dto.dart';
import 'package:mashena_rider/features/auth/data/models/signup_request_dto.dart';
import 'package:mashena_rider/features/auth/data/models/user_dto.dart';
import 'package:mashena_rider/features/auth/data/models/verify_otp_request_dto.dart';

abstract class AuthRemoteDataSource {
  Future<UserDto> signup(SignupRequestDto body);
  Future<LoginResponseDto> login(LoginRequestDto body);
  Future<void> sendOtp(SendOtpRequestDto body);
  Future<void> verifyOtp(VerifyOtpRequestDto body);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient api;

  AuthRemoteDataSourceImpl(this.api);

  @override
  Future<UserDto> signup(SignupRequestDto body) async {
    var data = await api.post(BackendEndpoints.signup, body: body.toJson());
    return UserDto.fromJson(data);
  }

  @override
  Future<LoginResponseDto> login(LoginRequestDto body) async {
    var data = await api.post(BackendEndpoints.login, body: body.toJson());
    return LoginResponseDto.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> sendOtp(SendOtpRequestDto body) async {
    await api.post(BackendEndpoints.sendOtpRider, body: body.toJson());
  }

  @override
  Future<void> verifyOtp(VerifyOtpRequestDto body) {
    return api.post(BackendEndpoints.verifyOtpRider, body: body.toJson());
  }
}
