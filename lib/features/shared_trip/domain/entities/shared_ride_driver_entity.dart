/// Represents driver information for a Shared Ride room.
class SharedRideDriverEntity {
  final int id;
  final int? userId;
  final String fullName;
  final String? city;
  final double? ratingAvg;
  final bool isOnline;

  const SharedRideDriverEntity({
    required this.id,
    this.userId,
    required this.fullName,
    this.city,
    this.ratingAvg,
    this.isOnline = false,
  });
}
