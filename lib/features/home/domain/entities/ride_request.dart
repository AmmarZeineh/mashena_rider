import 'package:freezed_annotation/freezed_annotation.dart';
import 'ride_location.dart';

part 'ride_request.freezed.dart';

@freezed
class RideRequest with _$RideRequest {
  const factory RideRequest({
    required RideLocation pickup,
    required RideLocation destination,
    @Default([]) List<RideLocation> stops,
  }) = _RideRequest;
}
