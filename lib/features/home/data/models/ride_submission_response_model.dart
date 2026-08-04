import 'package:json_annotation/json_annotation.dart';

import 'package:mashena_rider/core/network/json_readers.dart';

part 'ride_submission_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RideSubmissionResponseModel {
  const RideSubmissionResponseModel({
    required this.rideRequestId,
    required this.status,
    required this.distanceKm,
    required this.durationMin,
    required this.isNight,
    required this.estimatedFare,
    required this.currency,
  });

  factory RideSubmissionResponseModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;
    final normalized = Map<String, dynamic>.from(data);
    normalized['ride_request_id'] =
        data['ride_request_id'] ?? data['rideRequestId'] ?? data['id'];
    normalized['is_night'] = data['is_night'] ?? data['isNight'];
    normalized['distance_km'] = data['distance_km'] ?? data['distanceKm'];
    normalized['duration_min'] = data['duration_min'] ?? data['durationMin'];
    normalized['estimated_fare'] =
        data['estimated_fare'] ?? data['estimatedFare'];

    return _$RideSubmissionResponseModelFromJson(normalized);
  }

  @JsonKey(fromJson: readInt)
  final int rideRequestId;

  final String status;

  @JsonKey(fromJson: readDouble)
  final double distanceKm;

  @JsonKey(fromJson: readDouble)
  final double durationMin;

  @JsonKey(fromJson: readBool)
  final bool isNight;

  @JsonKey(fromJson: readDouble)
  final double estimatedFare;

  final String currency;

  Map<String, dynamic> toJson() => _$RideSubmissionResponseModelToJson(this);
}
