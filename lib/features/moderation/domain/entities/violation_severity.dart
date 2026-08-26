/// Severity level of a violation or penalty.
enum ViolationSeverity {
  low,
  medium,
  high,
  critical,
  unknown;

  static ViolationSeverity fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'LOW':
        return ViolationSeverity.low;
      case 'MEDIUM':
        return ViolationSeverity.medium;
      case 'HIGH':
        return ViolationSeverity.high;
      case 'CRITICAL':
        return ViolationSeverity.critical;
      default:
        return ViolationSeverity.unknown;
    }
  }

  String toBackendString() {
    switch (this) {
      case ViolationSeverity.low:
        return 'LOW';
      case ViolationSeverity.medium:
        return 'MEDIUM';
      case ViolationSeverity.high:
        return 'HIGH';
      case ViolationSeverity.critical:
        return 'CRITICAL';
      case ViolationSeverity.unknown:
        return 'UNKNOWN';
    }
  }
}
