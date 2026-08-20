enum RiderTripStatus {
  assigned('assigned'),
  enRouteToPickup('en_route_to_pickup'),
  arrived('arrived'),
  started('started'),
  completed('completed'),
  canceled('canceled');

  const RiderTripStatus(this.value);
  final String value;

  static RiderTripStatus? fromString(String? value) {
    if (value == null || value.isEmpty) return null;
    final lower = value.toLowerCase();
    for (final status in RiderTripStatus.values) {
      if (status.value == lower ||
          (status == RiderTripStatus.canceled && lower == 'cancelled')) {
        return status;
      }
    }
    return null;
  }
}
