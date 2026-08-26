import 'package:equatable/equatable.dart';
import 'package:mashena_rider/features/moderation/domain/entities/appeal_status.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_entity.dart';

/// Entity representing an appeal submitted by a rider against a penalty.
class AppealEntity extends Equatable {
  final int id;
  final int penaltyId;
  final int? userId;
  final String reason;
  final String? evidence;
  final AppealStatus status;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final int? reviewedByUserId;
  final String? adminDecision;
  final String? adminNotes;
  final PenaltyEntity? penalty;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AppealEntity({
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

  @override
  List<Object?> get props => [
    id,
    penaltyId,
    userId,
    reason,
    evidence,
    status,
    submittedAt,
    reviewedAt,
    reviewedByUserId,
    adminDecision,
    adminNotes,
    penalty,
    createdAt,
    updatedAt,
  ];
}
