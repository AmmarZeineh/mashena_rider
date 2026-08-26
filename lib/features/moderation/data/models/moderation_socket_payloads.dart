/// Socket payload when a penalty is issued in real-time (`moderation:penalty_issued`).
class PenaltyIssuedSocketPayload {
  final int penaltyId;
  final String penaltyType;
  final String reason;
  final DateTime? expiresAt;

  const PenaltyIssuedSocketPayload({
    required this.penaltyId,
    required this.penaltyType,
    required this.reason,
    this.expiresAt,
  });

  factory PenaltyIssuedSocketPayload.fromJson(Map<String, dynamic> json) {
    final rawId = json['penaltyId'];
    return PenaltyIssuedSocketPayload(
      penaltyId: rawId is int
          ? rawId
          : (int.tryParse(rawId?.toString() ?? '0') ?? 0),
      penaltyType: json['penaltyType'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'].toString())
          : null,
    );
  }
}

/// Socket payload when a restriction or penalty is lifted in real-time (`moderation:restriction_lifted`).
class RestrictionLiftedSocketPayload {
  final int penaltyId;
  final int? appealId;
  final String reason;

  const RestrictionLiftedSocketPayload({
    required this.penaltyId,
    this.appealId,
    required this.reason,
  });

  factory RestrictionLiftedSocketPayload.fromJson(Map<String, dynamic> json) {
    final rawPId = json['penaltyId'];
    final rawAId = json['appealId'];
    return RestrictionLiftedSocketPayload(
      penaltyId: rawPId is int
          ? rawPId
          : (int.tryParse(rawPId?.toString() ?? '0') ?? 0),
      appealId: rawAId != null
          ? (rawAId is int ? rawAId : int.tryParse(rawAId.toString()))
          : null,
      reason: json['reason'] as String? ?? '',
    );
  }
}
