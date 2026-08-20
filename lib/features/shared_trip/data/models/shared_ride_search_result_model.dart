import 'package:mashena_rider/core/network/json_readers.dart';
import '../../domain/entities/shared_ride_room_entity.dart';
import 'shared_ride_driver_model.dart';
import 'shared_ride_search_details_model.dart';
import 'shared_ride_vehicle_model.dart';

class SharedRideSearchResultModel {
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
  final SharedRideSearchDetailsModel? searchDetails;
  final SharedRideDriverModel? driver;
  final SharedRideVehicleModel? vehicle;

  const SharedRideSearchResultModel({
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

  factory SharedRideSearchResultModel.fromJson(Map<String, dynamic> json) {
    SharedRideSearchDetailsModel? searchDetails;
    if (json['searchDetails'] is Map<String, dynamic>) {
      searchDetails = SharedRideSearchDetailsModel.fromJson(
        json['searchDetails'] as Map<String, dynamic>,
      );
    }

    SharedRideDriverModel? driver;
    if (json['driverProfile'] is Map<String, dynamic>) {
      driver = SharedRideDriverModel.fromJson(
        json['driverProfile'] as Map<String, dynamic>,
      );
    } else if (json['driver'] is Map<String, dynamic>) {
      driver = SharedRideDriverModel.fromJson(
        json['driver'] as Map<String, dynamic>,
      );
    }

    SharedRideVehicleModel? vehicle;
    if (json['vehicle'] is Map<String, dynamic>) {
      vehicle = SharedRideVehicleModel.fromJson(
        json['vehicle'] as Map<String, dynamic>,
      );
    }

    final maxP = readInt(json['maxPassengers']);
    final occS = readInt(json['occupiedSeats']);
    final availS = json['availableSeats'] != null
        ? readInt(json['availableSeats'])
        : (maxP - occS).clamp(0, maxP);

    return SharedRideSearchResultModel(
      id: readInt(json['id']),
      driverProfileId: readInt(json['driverProfileId']),
      vehicleId: readInt(json['vehicleId']),
      status: json['status'] as String? ?? 'OPEN',
      endedBy: json['endedBy'] as String?,
      notes: json['notes'] as String?,
      originLat: readDouble(json['originLat']),
      originLng: readDouble(json['originLng']),
      originAddress: readStringOrEmpty(json['originAddress']),
      destLat: readDouble(json['destLat']),
      destLng: readDouble(json['destLng']),
      destAddress: readStringOrEmpty(json['destAddress']),
      departureTime: json['departureTime'] != null
          ? DateTime.tryParse(json['departureTime'].toString()) ??
                DateTime.now()
          : DateTime.now(),
      maxPassengers: maxP,
      occupiedSeats: occS,
      availableSeats: availS,
      totalDistanceKm: json['totalDistanceKm'] != null
          ? readDouble(json['totalDistanceKm'])
          : null,
      totalDurationSec: json['totalDurationSec'] != null
          ? readInt(json['totalDurationSec'])
          : null,
      routeGeometry: json['routeGeometry'],
      actualDistanceKm: json['actualDistanceKm'] != null
          ? readDouble(json['actualDistanceKm'])
          : null,
      actualDurationSec: json['actualDurationSec'] != null
          ? readInt(json['actualDurationSec'])
          : null,
      actualRouteGeometry: json['actualRouteGeometry'],
      baseTripFare: readDouble(json['baseTripFare']),
      remainingTripCost: readDouble(json['remainingTripCost']),
      occupiedSeatsAtStart: json['occupiedSeatsAtStart'] != null
          ? readInt(json['occupiedSeatsAtStart'])
          : null,
      fullRouteSeatFare: json['fullRouteSeatFare'] != null
          ? readDouble(json['fullRouteSeatFare'])
          : null,
      minimumSeatFare: json['minimumSeatFare'] != null
          ? readDouble(json['minimumSeatFare'])
          : null,
      startedAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt'].toString())
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'].toString())
          : null,
      canceledAt: json['canceledAt'] != null
          ? DateTime.tryParse(json['canceledAt'].toString())
          : null,
      cancellationReason: json['cancellationReason'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      searchDetails: searchDetails,
      driver: driver,
      vehicle: vehicle,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverProfileId': driverProfileId,
      'vehicleId': vehicleId,
      'status': status,
      if (endedBy != null) 'endedBy': endedBy,
      if (notes != null) 'notes': notes,
      'originLat': originLat,
      'originLng': originLng,
      'originAddress': originAddress,
      'destLat': destLat,
      'destLng': destLng,
      'destAddress': destAddress,
      'departureTime': departureTime.toIso8601String(),
      'maxPassengers': maxPassengers,
      'occupiedSeats': occupiedSeats,
      'availableSeats': availableSeats,
      if (totalDistanceKm != null) 'totalDistanceKm': totalDistanceKm,
      if (totalDurationSec != null) 'totalDurationSec': totalDurationSec,
      if (routeGeometry != null) 'routeGeometry': routeGeometry,
      if (actualDistanceKm != null) 'actualDistanceKm': actualDistanceKm,
      if (actualDurationSec != null) 'actualDurationSec': actualDurationSec,
      if (actualRouteGeometry != null)
        'actualRouteGeometry': actualRouteGeometry,
      'baseTripFare': baseTripFare,
      'remainingTripCost': remainingTripCost,
      if (occupiedSeatsAtStart != null)
        'occupiedSeatsAtStart': occupiedSeatsAtStart,
      if (fullRouteSeatFare != null) 'fullRouteSeatFare': fullRouteSeatFare,
      if (minimumSeatFare != null) 'minimumSeatFare': minimumSeatFare,
      if (startedAt != null) 'startedAt': startedAt!.toIso8601String(),
      if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
      if (canceledAt != null) 'canceledAt': canceledAt!.toIso8601String(),
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (searchDetails != null) 'searchDetails': searchDetails!.toJson(),
      if (driver != null) 'driverProfile': driver!.toJson(),
      if (vehicle != null) 'vehicle': vehicle!.toJson(),
    };
  }

  SharedRideRoomEntity toEntity() {
    return SharedRideRoomEntity(
      id: id,
      driverProfileId: driverProfileId,
      vehicleId: vehicleId,
      status: status,
      endedBy: endedBy,
      notes: notes,
      originLat: originLat,
      originLng: originLng,
      originAddress: originAddress,
      destLat: destLat,
      destLng: destLng,
      destAddress: destAddress,
      departureTime: departureTime,
      maxPassengers: maxPassengers,
      occupiedSeats: occupiedSeats,
      availableSeats: availableSeats,
      totalDistanceKm: totalDistanceKm,
      totalDurationSec: totalDurationSec,
      routeGeometry: routeGeometry,
      actualDistanceKm: actualDistanceKm,
      actualDurationSec: actualDurationSec,
      actualRouteGeometry: actualRouteGeometry,
      baseTripFare: baseTripFare,
      remainingTripCost: remainingTripCost,
      occupiedSeatsAtStart: occupiedSeatsAtStart,
      fullRouteSeatFare: fullRouteSeatFare,
      minimumSeatFare: minimumSeatFare,
      startedAt: startedAt,
      completedAt: completedAt,
      canceledAt: canceledAt,
      cancellationReason: cancellationReason,
      createdAt: createdAt,
      updatedAt: updatedAt,
      searchDetails: searchDetails?.toEntity(),
      driver: driver?.toEntity(),
      vehicle: vehicle?.toEntity(),
    );
  }
}
