import 'package:mashena_rider/features/moderation/domain/entities/restriction_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/restriction_type.dart';

class RestrictionModel {
  final int id;
  final int? userId;
  final int? penaltyId;
  final String restrictionType;
  final String status;
  final String reason;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final DateTime? revokedAt;
  final String? revocationReason;
  final DateTime? createdAt;

  const RestrictionModel({
    required this.id,
    this.userId,
    this.penaltyId,
    required this.restrictionType,
    required this.status,
    required this.reason,
    this.startsAt,
    this.expiresAt,
    this.revokedAt,
    this.revocationReason,
    this.createdAt,
  });

  factory RestrictionModel.fromJson(Map<String, dynamic> json) {
    return RestrictionModel(
      id: _toInt(json['id']) ?? 0,
      userId: _toInt(json['userId']),
      penaltyId: _toInt(json['penaltyId']),
      restrictionType: json['restrictionType'] as String? ?? 'UNKNOWN',
      status: json['status'] as String? ?? 'ACTIVE',
      reason: json['reason'] as String? ?? '',
      startsAt: _parseDateTime(json['startsAt']),
      expiresAt: _parseDateTime(json['expiresAt']),
      revokedAt: _parseDateTime(json['revokedAt']),
      revocationReason: json['revocationReason'] as String?,
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'penaltyId': penaltyId,
      'restrictionType': restrictionType,
      'status': status,
      'reason': reason,
      'startsAt': startsAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'revokedAt': revokedAt?.toIso8601String(),
      'revocationReason': revocationReason,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  RestrictionEntity toEntity() {
    return RestrictionEntity(
      id: id,
      userId: userId,
      penaltyId: penaltyId,
      restrictionType: RestrictionType.fromString(restrictionType),
      status: status,
      reason: reason,
      startsAt: startsAt,
      expiresAt: expiresAt,
      revokedAt: revokedAt,
      revocationReason: revocationReason,
      createdAt: createdAt,
    );
  }

  static int? _toInt(dynamic val) {
    if (val == null) return null;
    if (val is int) return val;
    if (val is num) return val.toInt();
    return int.tryParse(val.toString());
  }

  static DateTime? _parseDateTime(dynamic val) {
    if (val == null) return null;
    if (val is DateTime) return val;
    return DateTime.tryParse(val.toString());
  }
}
