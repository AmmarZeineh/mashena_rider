import 'package:json_annotation/json_annotation.dart';
import 'package:mashena_rider/core/network/json_readers.dart';

part 'ride_estimate_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RideEstimateModel {
  const RideEstimateModel({
    required this.vehicleTypeId,
    required this.name,
    required this.currency,
    required this.estimatedFare,
    this.imageUrl,
  });

  factory RideEstimateModel.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    normalized['vehicle_type_id'] =
        json['vehicle_type_id'] ?? json['vehicleTypeId'] ?? json['id'];
    normalized['name'] =
        json['name'] ?? json['vehicle_name'] ?? json['vehicleTypeName'];
    normalized['currency'] = json['currency'] ?? json['currency_code'];
    normalized['estimated_fare'] =
        json['estimated_fare'] ??
        json['estimatedFare'] ??
        json['estimated_price'] ??
        json['estimatedPrice'] ??
        json['fare'] ??
        json['price'];
    normalized['image_url'] =
        json['image_url'] ?? json['imageUrl'] ?? json['image'];

    return _$RideEstimateModelFromJson(normalized);
  }

  @JsonKey(fromJson: readInt)
  final int vehicleTypeId;

  @JsonKey(fromJson: readStringOrEmpty)
  final String name;

  @JsonKey(fromJson: readImageUrl)
  final String? imageUrl;

  @JsonKey(fromJson: readStringOrEmpty)
  final String currency;

  @JsonKey(fromJson: readDouble)
  final double estimatedFare;

  Map<String, dynamic> toJson() => _$RideEstimateModelToJson(this);
}
