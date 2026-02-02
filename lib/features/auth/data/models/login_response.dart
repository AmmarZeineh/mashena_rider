import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mashena_rider/features/auth/data/models/login_user_dto.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponseDto with _$LoginResponseDto {
  const factory LoginResponseDto({
    required String accessToken,
    required LoginUserDto user,
  }) = _LoginResponseDto;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);
}
