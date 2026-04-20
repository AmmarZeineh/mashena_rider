import 'package:json_annotation/json_annotation.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate.dart';

part 'ride_estimate_model.g.dart';

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

String? _readImageUrl(Object? value) {
  if (value is String && value.trim().isNotEmpty) return value.trim();

  if (value is Map) {
    for (final key in const ['url', 'imageUrl', 'path', 'src']) {
      final nestedValue = value[key];
      if (nestedValue is String && nestedValue.trim().isNotEmpty) {
        return nestedValue.trim();
      }
    }
  }

  return null;
}

String _readStringOrEmpty(Object? value) =>
    (value as String?)?.trim() ?? '';

@JsonSerializable(fieldRename: FieldRename.snake)
class RideEstimateModel {
  const RideEstimateModel({
    required this.vehicleTypeId,
    required this.name,
    required this.currency,
    required this.estimatedFare,
    this.imageUrl,
  });

  factory RideEstimateModel.fromJson(Map<String, dynamic> json) =>
      _$RideEstimateModelFromJson(json);

  @JsonKey(fromJson: _readInt)
  final int vehicleTypeId;

  @JsonKey(fromJson: _readStringOrEmpty)
  final String name;

  @JsonKey(fromJson: _readImageUrl)
  final String? imageUrl;

  @JsonKey(fromJson: _readStringOrEmpty)
  final String currency;

  @JsonKey(fromJson: _readDouble)
  final double estimatedFare;

  Map<String, dynamic> toJson() => _$RideEstimateModelToJson(this);

  RideEstimate toEntity() {
    return RideEstimate(
      vehicleTypeId: vehicleTypeId,
      name: name,
      imageUrl: imageUrl,
      currency: currency,
      estimatedFare: estimatedFare,
    );
  }
}
