import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/network/dio_client.dart';
import 'package:mashena_rider/features/auth/data/models/signup_request_dto.dart';
import 'package:mashena_rider/features/auth/data/models/user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<UserDto> signup(SignupRequestDto body);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient api;

  AuthRemoteDataSourceImpl(this.api);

  @override
  Future<UserDto> signup(SignupRequestDto body) async {
    var data = await api.post(BackendEndpoints.signup, body: body.toJson());
    return UserDto.fromJson(data);
  }
}
