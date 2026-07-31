class RiderProfile {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final DateTime createdAt;
  final double? ratingAvg;
  final int? ratingCount;
  final int? canceledTripsCount;

  const RiderProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
    this.ratingAvg,
    this.ratingCount,
    this.canceledTripsCount,
  });
}
