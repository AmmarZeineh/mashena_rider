import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/network/dio_client.dart';
import 'package:mashena_rider/features/auth/data/models/login_request_dto.dart';
import 'package:mashena_rider/features/auth/data/models/login_response.dart';
import 'package:mashena_rider/features/auth/data/models/signup_request_dto.dart';
import 'package:mashena_rider/features/auth/data/models/user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<UserDto> signup(SignupRequestDto body);
  Future<LoginResponseDto> login(LoginRequestDto body);
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
    final res = data.toString();
    print('LOGIN RAW => $res');

    return LoginResponseDto.fromJson(data as Map<String, dynamic>);
  }
}
