class DriverArrivedPayload {
  final int tripId;
  final String? arrivedAt;
  final int freeWaitTimeSeconds;

  const DriverArrivedPayload({
    required this.tripId,
    this.arrivedAt,
    this.freeWaitTimeSeconds = 300,
  });

  factory DriverArrivedPayload.fromJson(Map<String, dynamic> json) {
    return DriverArrivedPayload(
      tripId: int.tryParse(json['tripId']?.toString() ?? '0') ?? 0,
      arrivedAt: json['arrivedAt']?.toString(),
      freeWaitTimeSeconds:
          int.tryParse(json['freeWaitTimeSeconds']?.toString() ?? '300') ?? 300,
    );
  }
}
