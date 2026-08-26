import 'package:mashena_rider/features/moderation/data/models/penalty_model.dart';
import 'package:mashena_rider/features/moderation/domain/entities/appeal_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/appeal_status.dart';

class AppealModel {
  final int id;
  final int penaltyId;
  final int? userId;
  final String reason;
  final String? evidence;
  final String status;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final int? reviewedByUserId;
  final String? adminDecision;
  final String? adminNotes;
  final PenaltyModel? penalty;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AppealModel({
    required this.id,
    required this.penaltyId,
    this.userId,
    required this.reason,
    this.evidence,
    required this.status,
    this.submittedAt,
    this.reviewedAt,
    this.reviewedByUserId,
    this.adminDecision,
    this.adminNotes,
    this.penalty,
    this.createdAt,
    this.updatedAt,
  });

  factory AppealModel.fromJson(Map<String, dynamic> json) {
    return AppealModel(
      id: _toInt(json['id']) ?? 0,
      penaltyId: _toInt(json['penaltyId']) ?? 0,
      userId: _toInt(json['userId']),
      reason: json['reason'] as String? ?? '',
      evidence: json['evidence'] as String?,
      status: json['status'] as String? ?? 'PENDING',
      submittedAt: _parseDateTime(json['submittedAt']),
      reviewedAt: _parseDateTime(json['reviewedAt']),
      reviewedByUserId: _toInt(json['reviewedByUserId']),
      adminDecision: json['adminDecision'] as String?,
      adminNotes: json['adminNotes'] as String?,
      penalty: json['penalty'] != null && json['penalty'] is Map
          ? PenaltyModel.fromJson(
              Map<String, dynamic>.from(json['penalty'] as Map),
            )
          : null,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'penaltyId': penaltyId,
      'userId': userId,
      'reason': reason,
      'evidence': evidence,
      'status': status,
      'submittedAt': submittedAt?.toIso8601String(),
      'reviewedAt': reviewedAt?.toIso8601String(),
      'reviewedByUserId': reviewedByUserId,
      'adminDecision': adminDecision,
      'adminNotes': adminNotes,
      'penalty': penalty?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  AppealEntity toEntity() {
    return AppealEntity(
      id: id,
      penaltyId: penaltyId,
      userId: userId,
      reason: reason,
      evidence: evidence,
      status: AppealStatus.fromString(status),
      submittedAt: submittedAt,
      reviewedAt: reviewedAt,
      reviewedByUserId: reviewedByUserId,
      adminDecision: adminDecision,
      adminNotes: adminNotes,
      penalty: penalty?.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
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
