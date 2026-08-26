import 'package:equatable/equatable.dart';
import 'package:mashena_rider/features/moderation/domain/entities/restriction_type.dart';

/// Entity representing a feature restriction imposed on the rider.
class RestrictionEntity extends Equatable {
  final int id;
  final int? userId;
  final int? penaltyId;
  final RestrictionType restrictionType;
  final String status;
  final String reason;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final DateTime? revokedAt;
  final String? revocationReason;
  final DateTime? createdAt;

  const RestrictionEntity({
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

  bool get isActive => status.toUpperCase() == 'ACTIVE';

  @override
  List<Object?> get props => [
    id,
    userId,
    penaltyId,
    restrictionType,
    status,
    reason,
    startsAt,
    expiresAt,
    revokedAt,
    revocationReason,
    createdAt,
  ];
}
