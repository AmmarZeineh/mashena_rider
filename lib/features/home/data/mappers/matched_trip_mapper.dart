import '../../domain/entities/matched_trip.dart';
import '../models/matched_trip_model.dart';

extension MatchedTripModelMapper on MatchedTripModel {
  MatchedTrip toEntity() {
    String fullName = driverFullName ?? '';
    if (fullName.isEmpty) {
      final first = driverFirstName ?? '';
      final last = driverLastName ?? '';
      fullName = '$first $last'.trim();
    }
    if (fullName.isEmpty) {
      fullName = 'Driver';
    }

    return MatchedTrip(
      tripId: tripId,
      tripStatus: tripStatus,
      rideRequestId: rideRequestId,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      destinationLat: destinationLat,
      destinationLng: destinationLng,
      matchedAt: matchedAt,
      driverId: driverId,
      driverFullName: fullName,
      driverProfileImage: driverProfileImage,
      driverRatingAvg: driverRatingAvg,
      vehicleId: vehicleId,
      plateNumber: plateNumber,
      color: color,
      manufacturer: manufacturer,
      model: model,
      vehicleTypeId: vehicleTypeId,
      stops: stops.map((s) => s.toEntity()).toList(),
    );
  }
}
