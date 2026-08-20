import 'shared_ride_vehicle_type_entity.dart';

/// Represents vehicle details for a Shared Ride room.
class SharedRideVehicleEntity {
  final int id;
  final int? driverProfileId;
  final int? vehicleTypeId;
  final String plateNumber;
  final String model;
  final String color;
  final int? year;
  final String? photoUrl;
  final SharedRideVehicleTypeEntity? vehicleType;

  const SharedRideVehicleEntity({
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

  /// Convenient helper to get vehicle type name if available
  String get vehicleTypeName => vehicleType?.name ?? '';
}
