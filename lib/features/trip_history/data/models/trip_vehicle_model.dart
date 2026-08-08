import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mashena_rider/features/trip_history/domain/entities/trip_history_item.dart';

part 'trip_vehicle_model.freezed.dart';
part 'trip_vehicle_model.g.dart';

@freezed
abstract class TripVehicleModel with _$TripVehicleModel {
  const factory TripVehicleModel({
    String? plateNumber,
    String? model,
    String? color,
  }) = _TripVehicleModel;

  factory TripVehicleModel.fromJson(Map<String, dynamic> json) =>
      _$TripVehicleModelFromJson(json);
}

extension TripVehicleModelMapper on TripVehicleModel {
  TripVehicleEntity toEntity() => TripVehicleEntity(
        plateNumber: plateNumber,
        model: model,
        color: color,
      );
}
