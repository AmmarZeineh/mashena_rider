import 'shared_ride_driver_entity.dart';
import 'shared_ride_search_details_entity.dart';
import 'shared_ride_vehicle_entity.dart';

/// Represents a Shared Ride room found in search results.
class SharedRideRoomEntity {
  final int id;
  final int driverProfileId;
  final int vehicleId;
  final String status;
  final String? endedBy;
  final String? notes;
  final double originLat;
  final double originLng;
  final String originAddress;
  final double destLat;
  final double destLng;
  final String destAddress;
  final DateTime departureTime;
  final int maxPassengers;
  final int occupiedSeats;
  final int availableSeats;
  final double? totalDistanceKm;
  final int? totalDurationSec;
  final dynamic routeGeometry;
  final double? actualDistanceKm;
  final int? actualDurationSec;
  final dynamic actualRouteGeometry;
  final double baseTripFare;
  final double remainingTripCost;
  final int? occupiedSeatsAtStart;
  final double? fullRouteSeatFare;
  final double? minimumSeatFare;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? canceledAt;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SharedRideSearchDetailsEntity? searchDetails;
  final SharedRideDriverEntity? driver;
  final SharedRideVehicleEntity? vehicle;

  const SharedRideRoomEntity({
    required this.id,
    required this.driverProfileId,
    required this.vehicleId,
    required this.status,
    this.endedBy,
    this.notes,
    required this.originLat,
    required this.originLng,
    required this.originAddress,
    required this.destLat,
    required this.destLng,
    required this.destAddress,
    required this.departureTime,
    required this.maxPassengers,
    required this.occupiedSeats,
    required this.availableSeats,
    this.totalDistanceKm,
    this.totalDurationSec,
    this.routeGeometry,
    this.actualDistanceKm,
    this.actualDurationSec,
    this.actualRouteGeometry,
    required this.baseTripFare,
    required this.remainingTripCost,
    this.occupiedSeatsAtStart,
    this.fullRouteSeatFare,
    this.minimumSeatFare,
    this.startedAt,
    this.completedAt,
    this.canceledAt,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
    this.searchDetails,
    this.driver,
    this.vehicle,
  });

  bool get isOpen => status.toUpperCase() == 'OPEN';
  bool get isCanceled => status.toUpperCase() == 'CANCELED';
  bool get isFull => availableSeats <= 0;

  double get farePerSeat {
    if (fullRouteSeatFare != null && fullRouteSeatFare! > 0) {
      return fullRouteSeatFare!;
    }
    if (maxPassengers > 0) {
      return baseTripFare / maxPassengers;
    }
    return baseTripFare;
  }
}
