import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_otp_request_dto.freezed.dart';
part 'send_otp_request_dto.g.dart';

@freezed
class SendOtpRequestDto with _$SendOtpRequestDto {
  const factory SendOtpRequestDto({
    required String channel, // "email" or "phone"
    String? email,
    String? phone,
  }) = _SendOtpRequestDto;

  factory SendOtpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SendOtpRequestDtoFromJson(json);
}
