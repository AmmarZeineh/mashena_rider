/// Represents the general standing / status of a user's account.
enum UserAccountStatus {
  active,
  warning,
  restricted,
  suspended,
  banned;

  /// Parses a backend string value to [UserAccountStatus].
  static UserAccountStatus fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'WARNING':
        return UserAccountStatus.warning;
      case 'RESTRICTED':
        return UserAccountStatus.restricted;
      case 'SUSPENDED':
        return UserAccountStatus.suspended;
      case 'BANNED':
        return UserAccountStatus.banned;
      case 'ACTIVE':
      default:
        return UserAccountStatus.active;
    }
  }

  /// Whether the account has any disciplinary status active.
  bool get isClean => this == UserAccountStatus.active;
  bool get isBanned => this == UserAccountStatus.banned;
  bool get isSuspended => this == UserAccountStatus.suspended;
  bool get isRestricted => this == UserAccountStatus.restricted;
  bool get isWarning => this == UserAccountStatus.warning;
}
