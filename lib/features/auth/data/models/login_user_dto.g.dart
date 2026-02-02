// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginUserDtoImpl _$$LoginUserDtoImplFromJson(Map<String, dynamic> json) =>
    _$LoginUserDtoImpl(
      id: (json['id'] as num).toInt(),
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );

Map<String, dynamic> _$$LoginUserDtoImplToJson(_$LoginUserDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
    };
