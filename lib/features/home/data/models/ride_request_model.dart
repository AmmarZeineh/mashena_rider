import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/ride_request.dart';
import 'ride_location_model.dart';

part 'ride_request_model.freezed.dart';
part 'ride_request_model.g.dart';

@freezed
class RideRequestModel with _$RideRequestModel {
  const factory RideRequestModel({
    required RideLocationModel pickup,
    required RideLocationModel destination,
    @Default([]) List<RideLocationModel> stops,
  }) = _RideRequestModel;

  factory RideRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RideRequestModelFromJson(json);

  factory RideRequestModel.fromEntity(RideRequest entity) => RideRequestModel(
        pickup: RideLocationModel.fromEntity(entity.pickup),
        destination: RideLocationModel.fromEntity(entity.destination),
        stops: entity.stops.map((e) => RideLocationModel.fromEntity(e)).toList(),
      );
}
