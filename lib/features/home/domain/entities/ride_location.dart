import 'package:freezed_annotation/freezed_annotation.dart';

part 'ride_location.freezed.dart';

@freezed
abstract class RideLocation with _$RideLocation {
  const factory RideLocation({
    required double lat,
    required double lng,
    required String address,
  }) = _RideLocation;
}
