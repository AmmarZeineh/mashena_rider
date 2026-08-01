import '../../domain/entities/trip_completed.dart';
import '../models/trip_completed_payload.dart';

extension TripCompletedPayloadMapper on TripCompletedPayload {
  TripCompleted toEntity() {
    return TripCompleted(
      tripId: tripId,
      completedAt: completedAt,
      distanceKm: distanceKm,
      durationSec: durationSec,
    );
  }
}
