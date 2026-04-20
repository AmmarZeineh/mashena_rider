import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_request_dto.freezed.dart';
part 'signup_request_dto.g.dart';

@freezed
abstract class SignupRequestDto with _$SignupRequestDto {
  const factory SignupRequestDto({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) = _SignupRequestDto;

  factory SignupRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestDtoFromJson(json);
}
