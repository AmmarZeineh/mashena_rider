/// Request parameters for searching open Shared Rides.
class SearchSharedRideParams {
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final int seatsNeeded;
  final double maxDistanceKm;
  final String? departureDate;

  const SearchSharedRideParams({
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    this.seatsNeeded = 1,
    this.maxDistanceKm = 2.0,
    this.departureDate,
  });

  Map<String, dynamic> toQueryMap() {
    return {
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'dropoffLat': dropoffLat,
      'dropoffLng': dropoffLng,
      'seatsNeeded': seatsNeeded,
      'maxDistanceKm': maxDistanceKm,
      if (departureDate != null && departureDate!.isNotEmpty)
        'departureDate': departureDate,
    };
  }

  SearchSharedRideParams copyWith({
    double? pickupLat,
    double? pickupLng,
    double? dropoffLat,
    double? dropoffLng,
    int? seatsNeeded,
    double? maxDistanceKm,
    String? departureDate,
  }) {
    return SearchSharedRideParams(
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLng: pickupLng ?? this.pickupLng,
      dropoffLat: dropoffLat ?? this.dropoffLat,
      dropoffLng: dropoffLng ?? this.dropoffLng,
      seatsNeeded: seatsNeeded ?? this.seatsNeeded,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      departureDate: departureDate ?? this.departureDate,
    );
  }
}
