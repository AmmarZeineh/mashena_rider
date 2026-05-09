import 'package:json_annotation/json_annotation.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';

part 'ride_submission_response_model.g.dart';

int _readInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _readDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

bool _readBool(Object? value) {
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true';
  if (value is num) return value != 0;
  return false;
}

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

  @JsonKey(fromJson: _readInt)
  final int rideRequestId;

  final String status;

  @JsonKey(fromJson: _readDouble)
  final double distanceKm;

  @JsonKey(fromJson: _readDouble)
  final double durationMin;

  @JsonKey(fromJson: _readBool)
  final bool isNight;

  @JsonKey(fromJson: _readDouble)
  final double estimatedFare;

  final String currency;

  Map<String, dynamic> toJson() => _$RideSubmissionResponseModelToJson(this);

  RideSubmissionResponse toEntity() {
    return RideSubmissionResponse(
      rideRequestId: rideRequestId,
      status: status,
      distanceKm: distanceKm,
      durationMin: durationMin,
      isNight: isNight,
      estimatedFare: estimatedFare,
      currency: currency,
    );
  }
}
