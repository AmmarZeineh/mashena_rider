import '../../domain/entities/rider_profile.dart';
import '../models/rider_profile_model.dart';

extension RiderProfileModelMapper on RiderProfileModel {
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
