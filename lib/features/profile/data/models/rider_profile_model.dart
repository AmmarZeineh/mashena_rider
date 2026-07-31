import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mashena_rider/features/profile/domain/entities/rider_profile.dart';

part 'rider_profile_model.freezed.dart';
part 'rider_profile_model.g.dart';

@freezed
abstract class RiderProfileModel with _$RiderProfileModel {
  const RiderProfileModel._();

  const factory RiderProfileModel({
    required int id,
    required String fullName,
    required String email,
    required String phoneNumber,
    required DateTime createdAt,
    RiderProfileDto? riderProfile,
  }) = _RiderProfileModel;

  factory RiderProfileModel.fromJson(Map<String, dynamic> json) =>
      _$RiderProfileModelFromJson(json);

  RiderProfile toEntity() {
    return RiderProfile(
      id: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      createdAt: createdAt,
      ratingAvg: riderProfile?.ratingAvg,
      ratingCount: riderProfile?.ratingCount,
      canceledTripsCount: riderProfile?.canceledTripsCount,
    );
  }
}

@freezed
abstract class RiderProfileDto with _$RiderProfileDto {
  const factory RiderProfileDto({
    double? ratingAvg,
    int? ratingCount,
    int? canceledTripsCount,
  }) = _RiderProfileDto;

  factory RiderProfileDto.fromJson(Map<String, dynamic> json) =>
      _$RiderProfileDtoFromJson(json);
}
