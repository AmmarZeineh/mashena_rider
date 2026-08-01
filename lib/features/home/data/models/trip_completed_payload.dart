import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:mashena_rider/features/home/domain/entities/trip_completed.dart';

part 'trip_completed_payload.freezed.dart';
part 'trip_completed_payload.g.dart';

@freezed
abstract class TripCompletedPayload with _$TripCompletedPayload {
  const TripCompletedPayload._();

  const factory TripCompletedPayload({
    required int tripId,
    String? completedAt,
    num? distanceKm,
    num? durationSec,
  }) = _TripCompletedPayload;

  factory TripCompletedPayload.fromJson(Map<String, dynamic> json) =>
      _$TripCompletedPayloadFromJson(json);

}
