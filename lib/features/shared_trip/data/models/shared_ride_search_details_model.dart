import 'package:mashena_rider/core/network/json_readers.dart';
import '../../domain/entities/shared_ride_search_details_entity.dart';

class SharedRideSearchDetailsModel {
  final double originDistanceKm;
  final double destinationDistanceKm;

  const SharedRideSearchDetailsModel({
    required this.originDistanceKm,
    required this.destinationDistanceKm,
  });

  factory SharedRideSearchDetailsModel.fromJson(Map<String, dynamic> json) {
    return SharedRideSearchDetailsModel(
      originDistanceKm: readDouble(json['originDistanceKm']),
      destinationDistanceKm: readDouble(json['destinationDistanceKm']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originDistanceKm': originDistanceKm,
      'destinationDistanceKm': destinationDistanceKm,
    };
  }

  SharedRideSearchDetailsEntity toEntity() {
    return SharedRideSearchDetailsEntity(
      originDistanceKm: originDistanceKm,
      destinationDistanceKm: destinationDistanceKm,
    );
  }
}
