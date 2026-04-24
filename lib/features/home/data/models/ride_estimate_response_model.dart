import 'package:json_annotation/json_annotation.dart';
import 'package:mashena_rider/features/home/data/models/ride_estimate_model.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';

part 'ride_estimate_response_model.g.dart';

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

List<RideEstimateModel> _readEstimates(Object? value) {
  if (value is List) {
    return value.whereType<Map<dynamic, dynamic>>().map((e) {
      return RideEstimateModel.fromJson(Map<String, dynamic>.from(e));
    }).toList();
  }
  return const [];
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RideEstimateResponseModel {
  const RideEstimateResponseModel({
    required this.rideRequestId,
    required this.distanceKm,
    required this.durationMin,
    required this.stopsCount,
    this.estimates = const [],
  });

  factory RideEstimateResponseModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;
    final normalized = Map<String, dynamic>.from(data);
    normalized['ride_request_id'] =
        data['ride_request_id'] ?? data['rideRequestId'] ?? data['id'];
    normalized['distance_km'] = data['distance_km'] ?? data['distanceKm'];
    normalized['duration_min'] = data['duration_min'] ?? data['durationMin'];
    normalized['stops_count'] = data['stops_count'] ?? data['stopsCount'];
    normalized['estimates'] = data['estimates'] ?? data['vehicle_types'];

    return _$RideEstimateResponseModelFromJson(normalized);
  }

  @JsonKey(fromJson: _readInt)
  final int rideRequestId;

  @JsonKey(fromJson: _readDouble)
  final double distanceKm;

  @JsonKey(fromJson: _readDouble)
  final double durationMin;

  @JsonKey(fromJson: _readInt)
  final int stopsCount;

  @JsonKey(fromJson: _readEstimates)
  final List<RideEstimateModel> estimates;

  Map<String, dynamic> toJson() => _$RideEstimateResponseModelToJson(this);

  RideEstimateResponse toEntity() {
    return RideEstimateResponse(
      rideRequestId: rideRequestId,
      distanceKm: distanceKm,
      durationMin: durationMin,
      stopsCount: stopsCount,
      estimates: estimates.map((estimate) => estimate.toEntity()).toList(),
    );
  }
}
