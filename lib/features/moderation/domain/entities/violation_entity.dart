import 'package:equatable/equatable.dart';
import 'package:mashena_rider/features/moderation/domain/entities/violation_severity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/violation_type.dart';

/// Entity representing a violation committed by the rider.
class ViolationEntity extends Equatable {
  final int id;
  final int? userId;
  final String targetRole;
  final ViolationType violationType;
  final String? source;
  final ViolationSeverity severity;
  final String status;
  final String description;
  final String? sourceType;
  final String? sourceId;
  final int? penaltyId;
  final DateTime? occurredAt;
  final DateTime? createdAt;

  const ViolationEntity({
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

  @override
  List<Object?> get props => [
    id,
    userId,
    targetRole,
    violationType,
    source,
    severity,
    status,
    description,
    sourceType,
    sourceId,
    penaltyId,
    occurredAt,
    createdAt,
  ];
}
