import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mashena_rider/features/trip_history/data/models/trip_driver_model.dart';
import 'package:mashena_rider/features/trip_history/data/models/trip_rating_model.dart';
import 'package:mashena_rider/features/trip_history/data/models/trip_vehicle_model.dart';
import 'package:mashena_rider/features/trip_history/domain/entities/rider_trip_status.dart';
import 'package:mashena_rider/features/trip_history/domain/entities/trip_history_item.dart';

part 'trip_history_item_model.freezed.dart';
part 'trip_history_item_model.g.dart';

@freezed
abstract class TripHistoryItemModel with _$TripHistoryItemModel {
  const factory TripHistoryItemModel({
    required int id,
    int? rideRequestId,
    required String status,
    String? pickupAddress,
    double? pickupLat,
    double? pickupLng,
    String? destAddress,
    double? destLat,
    double? destLng,
    num? fareTotal,
    num? finalFare,
    num? discountAmount,
    double? distanceKm,
    int? durationSec,
    String? createdAt,
    String? acceptedAt,
    String? startedAt,
    String? completedAt,
    String? canceledAt,
    String? cancelledBy,
    TripDriverModel? driver,
    TripVehicleModel? vehicle,
    TripRatingModel? myRating,
  }) = _TripHistoryItemModel;

  factory TripHistoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$TripHistoryItemModelFromJson(json);
}

extension TripHistoryItemModelMapper on TripHistoryItemModel {
  TripHistoryItem toEntity() {
    return TripHistoryItem(
      id: id,
      rideRequestId: rideRequestId,
      status: status,
      statusEnum: RiderTripStatus.fromString(status),
      pickupAddress: pickupAddress ?? '',
      destAddress: destAddress ?? '',
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      destLat: destLat,
      destLng: destLng,
      finalFare: finalFare ?? fareTotal ?? 0,
      fareTotal: fareTotal,
      distanceKm: distanceKm,
      durationSec: durationSec,
      createdAt: createdAt,
      completedAt: completedAt,
      canceledAt: canceledAt,
      cancelledBy: cancelledBy,
      driver: driver?.toEntity(),
      vehicle: vehicle?.toEntity(),
    );
  }
}
