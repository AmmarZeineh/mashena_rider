import 'package:mashena_rider/features/auth/domain/entities/user.dart';
import 'package:mashena_rider/features/auth/data/models/login_user_dto.dart';

extension LoginUserDtoMapper on LoginUserDto {
  User toEntity() {
    return User(
      id: id,
      email: email,
      phoneNumber: phoneNumber,
      createdAt: DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
