import 'package:json_annotation/json_annotation.dart';
import 'package:mashena_rider/core/network/json_readers.dart';
import 'applied_coupon_model.dart';

part 'ride_estimate_model.g.dart';

AppliedCouponModel? _readAppliedCoupon(Object? value) {
  if (value is Map<String, dynamic>) {
    return AppliedCouponModel.fromJson(value);
  }
  if (value is Map) {
    return AppliedCouponModel.fromJson(Map<String, dynamic>.from(value));
  }
  return null;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RideEstimateModel {
  const RideEstimateModel({
    required this.vehicleTypeId,
    required this.name,
    required this.currency,
    required this.estimatedFare,
    this.imageUrl,
    this.originalFare,
    this.discountAmount,
    this.finalFare,
    this.appliedCoupon,
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
    normalized['original_fare'] = json['original_fare'] ?? json['originalFare'];
    normalized['discount_amount'] =
        json['discount_amount'] ?? json['discountAmount'];
    normalized['final_fare'] = json['final_fare'] ?? json['finalFare'];
    normalized['applied_coupon'] =
        json['applied_coupon'] ?? json['appliedCoupon'];

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

  @JsonKey(fromJson: readDoubleOptional)
  final double? originalFare;

  @JsonKey(fromJson: readDoubleOptional)
  final double? discountAmount;

  @JsonKey(fromJson: readDoubleOptional)
  final double? finalFare;

  @JsonKey(fromJson: _readAppliedCoupon)
  final AppliedCouponModel? appliedCoupon;

  Map<String, dynamic> toJson() => _$RideEstimateModelToJson(this);
}
