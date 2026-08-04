import 'package:equatable/equatable.dart';

class TripCompleted extends Equatable {
  final int tripId;
  final String? completedAt;
  final num? distanceKm;
  final num? durationSec;

  const TripCompleted({
    required this.tripId,
    this.completedAt,
    this.distanceKm,
    this.durationSec,
  });

  @override
  List<Object?> get props => [tripId, completedAt, distanceKm, durationSec];
}
