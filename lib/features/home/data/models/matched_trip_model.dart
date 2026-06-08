import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mashena_rider/features/home/domain/entities/matched_trip.dart';

part 'matched_trip_model.freezed.dart';
part 'matched_trip_model.g.dart';

@freezed
abstract class MatchedTripModel with _$MatchedTripModel {
  const MatchedTripModel._();

  const factory MatchedTripModel({
    required int tripId,
    required String tripStatus,
    required int rideRequestId,
    required double pickupLat,
    required double pickupLng,
    required double destinationLat,
    required double destinationLng,
    String? matchedAt,
    required int driverId,
    String? driverFullName,
    String? driverFirstName,
    String? driverLastName,
    String? driverProfileImage,
    required double driverRatingAvg,
    int? vehicleId,
    String? plateNumber,
    String? color,
    String? manufacturer,
    String? model,
    int? vehicleTypeId,
    @Default([]) List<dynamic> stops,
  }) = _MatchedTripModel;

  factory MatchedTripModel.fromJson(Map<String, dynamic> json) =>
      _$MatchedTripModelFromJson(json);

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
      stops: stops,
    );
  }
}
