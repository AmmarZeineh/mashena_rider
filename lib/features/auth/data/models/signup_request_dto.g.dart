// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignupRequestDtoImpl _$$SignupRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$SignupRequestDtoImpl(
  email: json['email'] as String,
  password: json['password'] as String,
  fullName: json['fullName'] as String,
  phoneNumber: json['phoneNumber'] as String,
);

Map<String, dynamic> _$$SignupRequestDtoImplToJson(
  _$SignupRequestDtoImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'fullName': instance.fullName,
  'phoneNumber': instance.phoneNumber,
};
