import '../../domain/entities/user.dart';
import '../models/user_dto.dart';

extension UserDtoMapper on UserDto {
  User toEntity() {
    return User(
      id: id,
      email: email,
      phoneNumber: phoneNumber,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
