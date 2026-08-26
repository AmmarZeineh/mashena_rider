import 'package:mashena_rider/features/moderation/data/models/appeal_model.dart';
import 'package:mashena_rider/features/moderation/data/models/penalty_model.dart';
import 'package:mashena_rider/features/moderation/data/models/restriction_model.dart';
import 'package:mashena_rider/features/moderation/data/models/violation_model.dart';
import 'package:mashena_rider/features/moderation/domain/entities/moderation_overview_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/user_account_status.dart';

class ModerationOverviewModel {
  final int userId;
  final String accountStatus;
  final int warningCount;
  final int totalViolationsCount;
  final List<PenaltyModel> activePenalties;
  final List<RestrictionModel> activeRestrictions;
  final List<ViolationModel> recentViolations;
  final List<AppealModel> activeAppeals;

  const ModerationOverviewModel({
    required this.userId,
    required this.accountStatus,
    required this.warningCount,
    required this.totalViolationsCount,
    required this.activePenalties,
    required this.activeRestrictions,
    required this.recentViolations,
    required this.activeAppeals,
  });

  factory ModerationOverviewModel.fromJson(Map<String, dynamic> json) {
    return ModerationOverviewModel(
      userId: _toInt(json['userId']) ?? 0,
      accountStatus: json['accountStatus'] as String? ?? 'ACTIVE',
      warningCount: _toInt(json['warningCount']) ?? 0,
      totalViolationsCount: _toInt(json['totalViolationsCount']) ?? 0,
      activePenalties: (json['activePenalties'] as List<dynamic>? ?? [])
          .map((e) => PenaltyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeRestrictions: (json['activeRestrictions'] as List<dynamic>? ?? [])
          .map((e) => RestrictionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentViolations: (json['recentViolations'] as List<dynamic>? ?? [])
          .map((e) => ViolationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeAppeals: (json['activeAppeals'] as List<dynamic>? ?? [])
          .map((e) => AppealModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'accountStatus': accountStatus,
      'warningCount': warningCount,
      'totalViolationsCount': totalViolationsCount,
      'activePenalties': activePenalties.map((e) => e.toJson()).toList(),
      'activeRestrictions': activeRestrictions.map((e) => e.toJson()).toList(),
      'recentViolations': recentViolations.map((e) => e.toJson()).toList(),
      'activeAppeals': activeAppeals.map((e) => e.toJson()).toList(),
    };
  }

  ModerationOverviewEntity toEntity() {
    return ModerationOverviewEntity(
      userId: userId,
      accountStatus: UserAccountStatus.fromString(accountStatus),
      warningCount: warningCount,
      totalViolationsCount: totalViolationsCount,
      activePenalties: activePenalties.map((e) => e.toEntity()).toList(),
      activeRestrictions: activeRestrictions.map((e) => e.toEntity()).toList(),
      recentViolations: recentViolations.map((e) => e.toEntity()).toList(),
      activeAppeals: activeAppeals.map((e) => e.toEntity()).toList(),
    );
  }

  static int? _toInt(dynamic val) {
    if (val == null) return null;
    if (val is int) return val;
    if (val is num) return val.toInt();
    return int.tryParse(val.toString());
  }
}
