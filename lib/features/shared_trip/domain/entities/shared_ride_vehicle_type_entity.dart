/// Represents the type/category of a vehicle (e.g. Sedan, SUV).
class SharedRideVehicleTypeEntity {
  final int id;
  final String name;
  final String? imageUrl;

  const SharedRideVehicleTypeEntity({
    required this.id,
    required this.name,
    this.imageUrl,
  });
}
