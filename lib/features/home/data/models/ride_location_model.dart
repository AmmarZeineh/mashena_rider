import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/ride_location.dart';

part 'ride_location_model.freezed.dart';
part 'ride_location_model.g.dart';

@freezed
abstract class RideLocationModel with _$RideLocationModel {
  const factory RideLocationModel({
    required double lat,
    required double lng,
    required String address,
  }) = _RideLocationModel;

  factory RideLocationModel.fromJson(Map<String, dynamic> json) =>
      _$RideLocationModelFromJson(json);

  factory RideLocationModel.fromEntity(RideLocation entity) => RideLocationModel(
        lat: entity.lat,
        lng: entity.lng,
        address: entity.address,
      );
}
