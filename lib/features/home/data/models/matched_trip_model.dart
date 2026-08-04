import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mashena_rider/features/home/data/models/ride_location_model.dart';

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
    @Default([]) List<RideLocationModel> stops,
  }) = _MatchedTripModel;

  factory MatchedTripModel.fromJson(Map<String, dynamic> json) =>
      _$MatchedTripModelFromJson(json);
}
