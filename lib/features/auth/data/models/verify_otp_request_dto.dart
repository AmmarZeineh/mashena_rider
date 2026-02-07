import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_otp_request_dto.freezed.dart';
part 'verify_otp_request_dto.g.dart';

@freezed
class VerifyOtpRequestDto with _$VerifyOtpRequestDto {
  const factory VerifyOtpRequestDto({
    String? email,
    String? phone,
    required String code,
  }) = _VerifyOtpRequestDto;

  factory VerifyOtpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestDtoFromJson(json);
}
