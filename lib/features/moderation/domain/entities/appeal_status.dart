/// Status of a user's appeal request.
enum AppealStatus {
  pending,
  underReview,
  approved,
  rejected,
  cancelled,
  unknown;

  static AppealStatus fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'PENDING':
        return AppealStatus.pending;
      case 'UNDER_REVIEW':
        return AppealStatus.underReview;
      case 'APPROVED':
        return AppealStatus.approved;
      case 'REJECTED':
        return AppealStatus.rejected;
      case 'CANCELLED':
        return AppealStatus.cancelled;
      default:
        return AppealStatus.unknown;
    }
  }

  bool get isPending => this == AppealStatus.pending;
  bool get isUnderReview => this == AppealStatus.underReview;
  bool get isApproved => this == AppealStatus.approved;
  bool get isRejected => this == AppealStatus.rejected;
}
