import '../../domain/entities/trip_cancelled.dart';
import '../models/trip_cancelled_payload.dart';

extension TripCancelledPayloadMapper on TripCancelledPayload {
  TripCancelled toEntity() {
    return TripCancelled(
      tripId: tripId,
      canceledAt: canceledAt,
      cancelledBy: cancelledBy,
    );
  }
}
