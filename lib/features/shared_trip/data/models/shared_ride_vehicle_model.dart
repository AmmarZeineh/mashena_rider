import 'package:mashena_rider/core/network/json_readers.dart';
import '../../domain/entities/shared_ride_vehicle_entity.dart';
import 'shared_ride_vehicle_type_model.dart';

class SharedRideVehicleModel {
  final int id;
  final int? driverProfileId;
  final int? vehicleTypeId;
  final String plateNumber;
  final String model;
  final String color;
  final int? year;
  final String? photoUrl;
  final SharedRideVehicleTypeModel? vehicleType;

  const SharedRideVehicleModel({
    required this.id,
    this.driverProfileId,
    this.vehicleTypeId,
    required this.plateNumber,
    required this.model,
    required this.color,
    this.year,
    this.photoUrl,
    this.vehicleType,
  });

  factory SharedRideVehicleModel.fromJson(Map<String, dynamic> json) {
    SharedRideVehicleTypeModel? type;
    if (json['vehicleType'] is Map<String, dynamic>) {
      type = SharedRideVehicleTypeModel.fromJson(
        json['vehicleType'] as Map<String, dynamic>,
      );
    }

    return SharedRideVehicleModel(
      id: readInt(json['id']),
      driverProfileId: json['driverProfileId'] != null
          ? readInt(json['driverProfileId'])
          : null,
      vehicleTypeId: json['vehicleTypeId'] != null
          ? readInt(json['vehicleTypeId'])
          : null,
      plateNumber: readStringOrEmpty(json['plateNumber']),
      model: readStringOrEmpty(json['model']),
      color: readStringOrEmpty(json['color']),
      year: json['year'] != null ? readInt(json['year']) : null,
      photoUrl: readImageUrl(json['photoUrl']),
      vehicleType: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (driverProfileId != null) 'driverProfileId': driverProfileId,
      if (vehicleTypeId != null) 'vehicleTypeId': vehicleTypeId,
      'plateNumber': plateNumber,
      'model': model,
      'color': color,
      if (year != null) 'year': year,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (vehicleType != null) 'vehicleType': vehicleType!.toJson(),
    };
  }

  SharedRideVehicleEntity toEntity() {
    return SharedRideVehicleEntity(
      id: id,
      driverProfileId: driverProfileId,
      vehicleTypeId: vehicleTypeId,
      plateNumber: plateNumber,
      model: model,
      color: color,
      year: year,
      photoUrl: photoUrl,
      vehicleType: vehicleType?.toEntity(),
    );
  }
}
