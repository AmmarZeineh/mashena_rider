import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:mashena_rider/features/home/domain/entities/trip_cancelled.dart';

part 'trip_cancelled_payload.freezed.dart';
part 'trip_cancelled_payload.g.dart';

@freezed
abstract class TripCancelledPayload with _$TripCancelledPayload {
  const TripCancelledPayload._();

  const factory TripCancelledPayload({
    required int tripId,
    String? canceledAt,
    String? cancelledBy,
  }) = _TripCancelledPayload;

  factory TripCancelledPayload.fromJson(Map<String, dynamic> json) =>
      _$TripCancelledPayloadFromJson(json);

  TripCancelled toEntity() {
    return TripCancelled(
      tripId: tripId,
      canceledAt: canceledAt,
      cancelledBy: cancelledBy,
    );
  }
}
