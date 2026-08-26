import 'package:equatable/equatable.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_status.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_type.dart';
import 'package:mashena_rider/features/moderation/domain/entities/restriction_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/violation_severity.dart';

/// Entity representing a penalty record for a user.
class PenaltyEntity extends Equatable {
  final int id;
  final int? userId;
  final String targetRole;
  final PenaltyType penaltyType;
  final ViolationSeverity severity;
  final PenaltyStatus status;
  final String reason;
  final String? issuedByType;
  final int? issuedByUserId;
  final int? ruleId;
  final DateTime? issuedAt;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final DateTime? revokedAt;
  final String? revocationReason;
  final List<RestrictionEntity> restrictions;
  final DateTime? createdAt;

  const PenaltyEntity({
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

  /// An active penalty can be appealed.
  bool get isAppealable => status == PenaltyStatus.active;

  /// Whether this is a permanent ban (expiresAt is null and type is permanentBan).
  bool get isPermanentBan =>
      penaltyType == PenaltyType.permanentBan ||
      (status == PenaltyStatus.active && expiresAt == null);

  @override
  List<Object?> get props => [
    id,
    userId,
    targetRole,
    penaltyType,
    severity,
    status,
    reason,
    issuedByType,
    issuedByUserId,
    ruleId,
    issuedAt,
    startsAt,
    expiresAt,
    revokedAt,
    revocationReason,
    restrictions,
    createdAt,
  ];
}
