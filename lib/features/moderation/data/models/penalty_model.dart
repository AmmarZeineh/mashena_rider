import 'package:mashena_rider/features/moderation/data/models/restriction_model.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_status.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_type.dart';
import 'package:mashena_rider/features/moderation/domain/entities/violation_severity.dart';

class PenaltyModel {
  final int id;
  final int? userId;
  final String targetRole;
  final String penaltyType;
  final String severity;
  final String status;
  final String reason;
  final String? issuedByType;
  final int? issuedByUserId;
  final int? ruleId;
  final DateTime? issuedAt;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final DateTime? revokedAt;
  final String? revocationReason;
  final List<RestrictionModel> restrictions;
  final DateTime? createdAt;

  const PenaltyModel({
    required this.id,
    this.userId,
    this.targetRole = 'RIDER',
    required this.penaltyType,
    required this.severity,
    required this.status,
    required this.reason,
    this.issuedByType,
    this.issuedByUserId,
    this.ruleId,
    this.issuedAt,
    this.startsAt,
    this.expiresAt,
    this.revokedAt,
    this.revocationReason,
    this.restrictions = const [],
    this.createdAt,
  });

  factory PenaltyModel.fromJson(Map<String, dynamic> json) {
    return PenaltyModel(
      id: _toInt(json['id']) ?? 0,
      userId: _toInt(json['userId']),
      targetRole: json['targetRole'] as String? ?? 'RIDER',
      penaltyType: json['penaltyType'] as String? ?? 'WARNING',
      severity: json['severity'] as String? ?? 'LOW',
      status: json['status'] as String? ?? 'ACTIVE',
      reason: json['reason'] as String? ?? '',
      issuedByType: json['issuedByType'] as String?,
      issuedByUserId: _toInt(json['issuedByUserId']),
      ruleId: _toInt(json['ruleId']),
      issuedAt: _parseDateTime(json['issuedAt']),
      startsAt: _parseDateTime(json['startsAt']),
      expiresAt: _parseDateTime(json['expiresAt']),
      revokedAt: _parseDateTime(json['revokedAt']),
      revocationReason: json['revocationReason'] as String?,
      restrictions: (json['restrictions'] as List<dynamic>? ?? [])
          .map((e) => RestrictionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'targetRole': targetRole,
      'penaltyType': penaltyType,
      'severity': severity,
      'status': status,
      'reason': reason,
      'issuedByType': issuedByType,
      'issuedByUserId': issuedByUserId,
      'ruleId': ruleId,
      'issuedAt': issuedAt?.toIso8601String(),
      'startsAt': startsAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'revokedAt': revokedAt?.toIso8601String(),
      'revocationReason': revocationReason,
      'restrictions': restrictions.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  PenaltyEntity toEntity() {
    return PenaltyEntity(
      id: id,
      userId: userId,
      targetRole: targetRole,
      penaltyType: PenaltyType.fromString(penaltyType),
      severity: ViolationSeverity.fromString(severity),
      status: PenaltyStatus.fromString(status),
      reason: reason,
      issuedByType: issuedByType,
      issuedByUserId: issuedByUserId,
      ruleId: ruleId,
      issuedAt: issuedAt,
      startsAt: startsAt,
      expiresAt: expiresAt,
      revokedAt: revokedAt,
      revocationReason: revocationReason,
      restrictions: restrictions.map((e) => e.toEntity()).toList(),
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
