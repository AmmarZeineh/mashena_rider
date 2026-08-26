import 'package:mashena_rider/features/moderation/domain/entities/violation_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/violation_severity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/violation_type.dart';

class ViolationModel {
  final int id;
  final int? userId;
  final String targetRole;
  final String violationType;
  final String? source;
  final String severity;
  final String status;
  final String description;
  final String? sourceType;
  final String? sourceId;
  final int? penaltyId;
  final DateTime? occurredAt;
  final DateTime? createdAt;

  const ViolationModel({
    required this.id,
    this.userId,
    this.targetRole = 'RIDER',
    required this.violationType,
    this.source,
    required this.severity,
    required this.status,
    required this.description,
    this.sourceType,
    this.sourceId,
    this.penaltyId,
    this.occurredAt,
    this.createdAt,
  });

  factory ViolationModel.fromJson(Map<String, dynamic> json) {
    return ViolationModel(
      id: _toInt(json['id']) ?? 0,
      userId: _toInt(json['userId']),
      targetRole: json['targetRole'] as String? ?? 'RIDER',
      violationType:
          json['violationType'] as String? ?? 'RIDER_TRIP_CANCELLATION',
      source: json['source'] as String?,
      severity: json['severity'] as String? ?? 'LOW',
      status: json['status'] as String? ?? 'PROCESSED',
      description: json['description'] as String? ?? '',
      sourceType: json['sourceType'] as String?,
      sourceId: json['sourceId']?.toString(),
      penaltyId: _toInt(json['penaltyId']),
      occurredAt: _parseDateTime(json['occurredAt']),
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'targetRole': targetRole,
      'violationType': violationType,
      'source': source,
      'severity': severity,
      'status': status,
      'description': description,
      'sourceType': sourceType,
      'sourceId': sourceId,
      'penaltyId': penaltyId,
      'occurredAt': occurredAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  ViolationEntity toEntity() {
    return ViolationEntity(
      id: id,
      userId: userId,
      targetRole: targetRole,
      violationType: ViolationType.fromString(violationType),
      source: source,
      severity: ViolationSeverity.fromString(severity),
      status: status,
      description: description,
      sourceType: sourceType,
      sourceId: sourceId,
      penaltyId: penaltyId,
      occurredAt: occurredAt,
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
