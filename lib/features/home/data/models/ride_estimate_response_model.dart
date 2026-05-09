import 'package:json_annotation/json_annotation.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/features/home/data/models/ride_estimate_model.dart';
import 'package:mashena_rider/features/home/data/models/ride_location_model.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';

part 'ride_estimate_response_model.g.dart';

int? _readIntOptional(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

int _readInt(Object? value) {
  return _readIntOptional(value) ?? 0;
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

List<RideEstimateModel> _readEstimates(Object? value) {
  if (value is List) {
    return value.whereType<Map<dynamic, dynamic>>().map((e) {
      return RideEstimateModel.fromJson(Map<String, dynamic>.from(e));
    }).toList();
  }
  return const [];
}

List<MapLatLng> _readStops(Object? value) {
  if (value is List) {
    return value.map((e) {
      if (e is Map) {
        final lat = (e['lat'] ?? e['latitude'] ?? 0) as num;
        final lng = (e['lng'] ?? e['longitude'] ?? 0) as num;
        return MapLatLng(latitude: lat.toDouble(), longitude: lng.toDouble());
      }
      return const MapLatLng(latitude: 0, longitude: 0);
    }).toList();
  }
  return const [];
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RideEstimateResponseModel {
  const RideEstimateResponseModel({
    this.rideRequestId,
    required this.distanceKm,
    required this.durationMin,
    required this.stopsCount,
    required this.isNight,
    this.pickup,
    this.destination,
    this.estimates = const [],
    this.polyline,
    this.stops = const [],
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
    normalized['is_night'] = data['is_night'] ?? data['isNight'];
    normalized['estimates'] = data['estimates'] ?? data['vehicle_types'];
    normalized['polyline'] =
        data['polyline'] ?? data['geometry'] ?? data['route'];

    return _$RideEstimateResponseModelFromJson(normalized);
  }

  @JsonKey(fromJson: _readIntOptional)
  final int? rideRequestId;

  @JsonKey(fromJson: _readDouble)
  final double distanceKm;

  @JsonKey(fromJson: _readDouble)
  final double durationMin;

  @JsonKey(fromJson: _readInt)
  final int stopsCount;

  @JsonKey(fromJson: _readBool)
  final bool isNight;

  final RideLocationModel? pickup;
  final RideLocationModel? destination;

  @JsonKey(fromJson: _readEstimates)
  final List<RideEstimateModel> estimates;

  final String? polyline;

  @JsonKey(fromJson: _readStops, includeToJson: false)
  final List<MapLatLng> stops;

  Map<String, dynamic> toJson() => _$RideEstimateResponseModelToJson(this);

  RideEstimateResponse toEntity() {
    return RideEstimateResponse(
      rideRequestId: rideRequestId,
      distanceKm: distanceKm,
      durationMin: durationMin,
      stopsCount: stopsCount,
      isNight: isNight,
      pickup: pickup?.toEntity(),
      destination: destination?.toEntity(),
      estimates: estimates.map((estimate) => estimate.toEntity()).toList(),
      polyline: polyline,
      stops: stops,
    );
  }
}
