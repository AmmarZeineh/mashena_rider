import 'package:freezed_annotation/freezed_annotation.dart';

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
}
