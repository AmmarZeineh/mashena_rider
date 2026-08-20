import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'shared_ride_driver_entity.dart';
import 'shared_ride_passenger_entity.dart';
import 'shared_ride_vehicle_entity.dart';

/// Full room details entity for a specific Shared Ride room.
class SharedRideRoomDetailsEntity {
  final int id;
  final int driverProfileId;
  final int vehicleId;
  final SharedRideDriverEntity? driver;
  final SharedRideVehicleEntity? vehicle;
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
  final double? totalDistanceKm;
  final int? totalDurationSec;
  final dynamic routeGeometry;
  final double? actualDistanceKm;
  final int? actualDurationSec;
  final dynamic actualRouteGeometry;
  final double? baseTripFare;
  final double? remainingTripCost;
  final int? occupiedSeatsAtStart;
  final double? fullRouteSeatFare;
  final double? minimumSeatFare;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? canceledAt;
  final String? cancellationReason;
  final String? endType;
  final DateTime createdAt;
  final List<SharedRidePassengerEntity> passengers;

  const SharedRideRoomDetailsEntity({
    required this.id,
    required this.driverProfileId,
    required this.vehicleId,
    this.driver,
    this.vehicle,
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
    this.totalDistanceKm,
    this.totalDurationSec,
    this.routeGeometry,
    this.actualDistanceKm,
    this.actualDurationSec,
    this.actualRouteGeometry,
    this.baseTripFare,
    this.remainingTripCost,
    this.occupiedSeatsAtStart,
    this.fullRouteSeatFare,
    this.minimumSeatFare,
    this.startedAt,
    this.completedAt,
    this.canceledAt,
    this.cancellationReason,
    this.endType,
    required this.createdAt,
    this.passengers = const [],
  });

  int get availableSeats =>
      (maxPassengers - occupiedSeats).clamp(0, maxPassengers);

  bool get isOpen => status.toUpperCase() == 'OPEN';
  bool get isReady => status.toUpperCase() == 'READY';
  bool get isInProgress => status.toUpperCase() == 'IN_PROGRESS';
  bool get isCompleted => status.toUpperCase() == 'COMPLETED';
  bool get isCanceled => status.toUpperCase() == 'CANCELED';
  bool get isFull => availableSeats <= 0;

  double get effectiveSeatFare {
    if (fullRouteSeatFare != null && fullRouteSeatFare! > 0) {
      return fullRouteSeatFare!;
    }
    if (baseTripFare != null && baseTripFare! > 0 && maxPassengers > 0) {
      return baseTripFare! / maxPassengers;
    }
    return minimumSeatFare ?? 0.0;
  }

  /// Parses route geometry into map coordinates if available.
  List<MapLatLng> get routePoints {
    final points = <MapLatLng>[];
    if (routeGeometry is Map<String, dynamic>) {
      final geom = routeGeometry as Map<String, dynamic>;
      final coordinates = geom['coordinates'];
      if (coordinates is List) {
        for (final coord in coordinates) {
          if (coord is List && coord.length >= 2) {
            // GeoJSON coordinates are [longitude, latitude]
            final lng = (coord[0] as num).toDouble();
            final lat = (coord[1] as num).toDouble();
            points.add(MapLatLng(latitude: lat, longitude: lng));
          }
        }
      }
    } else if (routeGeometry is List) {
      for (final item in routeGeometry as List) {
        if (item is List && item.length >= 2) {
          final lng = (item[0] as num).toDouble();
          final lat = (item[1] as num).toDouble();
          points.add(MapLatLng(latitude: lat, longitude: lng));
        } else if (item is Map) {
          final lat = (item['lat'] ?? item['latitude']) as num?;
          final lng = (item['lng'] ?? item['longitude']) as num?;
          if (lat != null && lng != null) {
            points.add(
              MapLatLng(latitude: lat.toDouble(), longitude: lng.toDouble()),
            );
          }
        }
      }
    }

    if (points.isEmpty) {
      points.add(MapLatLng(latitude: originLat, longitude: originLng));
      points.add(MapLatLng(latitude: destLat, longitude: destLng));
    }
    return points;
  }
}
