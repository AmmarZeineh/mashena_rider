import 'package:json_annotation/json_annotation.dart';
import 'package:mashena_rider/core/network/json_readers.dart';
import '../../domain/entities/applied_coupon.dart';

part 'applied_coupon_model.g.dart';

int? _readOptionalInt(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

DateTime? _readOptionalDateTime(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) return DateTime.tryParse(value);
  return null;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AppliedCouponModel {
  const AppliedCouponModel({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    this.remainingUsages,
    this.expiresAt,
  });

  factory AppliedCouponModel.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    normalized['remaining_usages'] =
        json['remaining_usages'] ?? json['remainingUsages'];
    normalized['expires_at'] = json['expires_at'] ?? json['expiresAt'];
    return _$AppliedCouponModelFromJson(normalized);
  }

  @JsonKey(fromJson: readInt)
  final int id;

  @JsonKey(fromJson: readStringOrEmpty)
  final String code;

  @JsonKey(fromJson: readStringOrEmpty)
  final String type;

  @JsonKey(fromJson: readDouble)
  final double value;

  @JsonKey(fromJson: _readOptionalInt)
  final int? remainingUsages;

  @JsonKey(fromJson: _readOptionalDateTime)
  final DateTime? expiresAt;

  Map<String, dynamic> toJson() => _$AppliedCouponModelToJson(this);

  AppliedCoupon toEntity() => AppliedCoupon(
    id: id,
    code: code,
    type: type,
    value: value,
    remainingUsages: remainingUsages,
    expiresAt: expiresAt,
  );
}
