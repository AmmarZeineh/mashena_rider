import 'package:mashena_rider/core/network/json_readers.dart';
import '../../domain/entities/shared_ride_driver_entity.dart';

class SharedRideDriverModel {
  final int id;
  final int? userId;
  final String fullName;
  final String? city;
  final double? ratingAvg;
  final bool isOnline;

  const SharedRideDriverModel({
    required this.id,
    this.userId,
    required this.fullName,
    this.city,
    this.ratingAvg,
    this.isOnline = false,
  });

  factory SharedRideDriverModel.fromJson(Map<String, dynamic> json) {
    String name = readStringOrEmpty(json['fullName']);
    if (name.isEmpty && json['user'] is Map) {
      name = readStringOrEmpty((json['user'] as Map)['fullName']);
    }

    final ratingRaw = json['ratingAvg'];
    final rating = ratingRaw != null ? readDouble(ratingRaw) : null;

    return SharedRideDriverModel(
      id: readInt(json['id']),
      userId: json['userId'] != null ? readInt(json['userId']) : null,
      fullName: name,
      city: json['city'] as String?,
      ratingAvg: rating,
      isOnline: readBool(json['isOnline']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (userId != null) 'userId': userId,
      'fullName': fullName,
      if (city != null) 'city': city,
      if (ratingAvg != null) 'ratingAvg': ratingAvg,
      'isOnline': isOnline,
    };
  }

  SharedRideDriverEntity toEntity() {
    return SharedRideDriverEntity(
      id: id,
      userId: userId,
      fullName: fullName,
      city: city,
      ratingAvg: ratingAvg,
      isOnline: isOnline,
    );
  }
}
