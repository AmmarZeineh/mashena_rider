import 'package:mashena_rider/core/network/json_readers.dart';
import '../../domain/entities/shared_ride_vehicle_type_entity.dart';

class SharedRideVehicleTypeModel {
  final int id;
  final String name;
  final String? imageUrl;

  const SharedRideVehicleTypeModel({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory SharedRideVehicleTypeModel.fromJson(Map<String, dynamic> json) {
    return SharedRideVehicleTypeModel(
      id: readInt(json['id']),
      name: readStringOrEmpty(json['name']),
      imageUrl: readImageUrl(json['imageUrl']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, if (imageUrl != null) 'imageUrl': imageUrl};
  }

  SharedRideVehicleTypeEntity toEntity() {
    return SharedRideVehicleTypeEntity(id: id, name: name, imageUrl: imageUrl);
  }
}
