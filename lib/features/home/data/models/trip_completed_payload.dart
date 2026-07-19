import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_completed_payload.freezed.dart';
part 'trip_completed_payload.g.dart';

@freezed
abstract class TripCompletedPayload with _$TripCompletedPayload {
  const factory TripCompletedPayload({
    required int tripId,
    String? completedAt,
    num? distanceKm,
    num? durationSec,
  }) = _TripCompletedPayload;

  factory TripCompletedPayload.fromJson(Map<String, dynamic> json) =>
      _$TripCompletedPayloadFromJson(json);
}
