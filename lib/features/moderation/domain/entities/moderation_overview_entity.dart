import 'package:equatable/equatable.dart';
import 'package:mashena_rider/features/moderation/domain/entities/appeal_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/restriction_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/user_account_status.dart';
import 'package:mashena_rider/features/moderation/domain/entities/violation_entity.dart';

/// Entity representing the overall moderation status and summary for a user.
class ModerationOverviewEntity extends Equatable {
  final int userId;
  final UserAccountStatus accountStatus;
  final int warningCount;
  final int totalViolationsCount;
  final List<PenaltyEntity> activePenalties;
  final List<RestrictionEntity> activeRestrictions;
  final List<ViolationEntity> recentViolations;
  final List<AppealEntity> activeAppeals;

  const ModerationOverviewEntity({
    required this.userId,
    required this.accountStatus,
    required this.warningCount,
    required this.totalViolationsCount,
    required this.activePenalties,
    required this.activeRestrictions,
    required this.recentViolations,
    required this.activeAppeals,
  });

  bool get hasActiveRestrictions => activeRestrictions.isNotEmpty;
  bool get hasActivePenalties => activePenalties.isNotEmpty;

  @override
  List<Object?> get props => [
    userId,
    accountStatus,
    warningCount,
    totalViolationsCount,
    activePenalties,
    activeRestrictions,
    recentViolations,
    activeAppeals,
  ];
}
