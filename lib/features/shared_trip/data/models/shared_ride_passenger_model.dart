import 'package:mashena_rider/core/network/json_readers.dart';
import '../../domain/entities/shared_ride_passenger_entity.dart';

class SharedRidePassengerModel {
  final int id;
  final int sharedRideId;
  final int riderProfileId;
  final String? riderName;
  final String status;
  final String paymentStatus;
  final int seatsNeeded;
  final int activeSeats;
  final double totalPaidFare;
  final double? finalDistanceKm;
  final int? finalDurationSec;
  final double? finalFare;
  final DateTime joinedAt;
  final DateTime? onBoardAt;
  final DateTime? droppedOffAt;
  final bool accountHolderOnBoard;
  final DateTime? accountHolderDroppedOffAt;
  final DateTime? leftAt;
  final DateTime? canceledAt;
  final DateTime? removedAt;
  final String? removeReason;

  const SharedRidePassengerModel({
    required this.id,
    required this.sharedRideId,
    required this.riderProfileId,
    this.riderName,
    required this.status,
    required this.paymentStatus,
    required this.seatsNeeded,
    required this.activeSeats,
    required this.totalPaidFare,
    this.finalDistanceKm,
    this.finalDurationSec,
    this.finalFare,
    required this.joinedAt,
    this.onBoardAt,
    this.droppedOffAt,
    this.accountHolderOnBoard = false,
    this.accountHolderDroppedOffAt,
    this.leftAt,
    this.canceledAt,
    this.removedAt,
    this.removeReason,
  });

  factory SharedRidePassengerModel.fromJson(Map<String, dynamic> json) {
    return SharedRidePassengerModel(
      id: readInt(json['id']),
      sharedRideId: readInt(json['sharedRideId']),
      riderProfileId: readInt(json['riderProfileId']),
      riderName: json['riderName'] as String?,
      status: json['status'] as String? ?? 'JOINED',
      paymentStatus: json['paymentStatus'] as String? ?? 'PENDING',
      seatsNeeded: readInt(json['seatsNeeded']),
      activeSeats: readInt(json['activeSeats']),
      totalPaidFare: readDouble(json['totalPaidFare']),
      finalDistanceKm: json['finalDistanceKm'] != null
          ? readDouble(json['finalDistanceKm'])
          : null,
      finalDurationSec: json['finalDurationSec'] != null
          ? readInt(json['finalDurationSec'])
          : null,
      finalFare: json['finalFare'] != null
          ? readDouble(json['finalFare'])
          : null,
      joinedAt: json['joinedAt'] != null
          ? DateTime.tryParse(json['joinedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      onBoardAt: json['onBoardAt'] != null
          ? DateTime.tryParse(json['onBoardAt'].toString())
          : null,
      droppedOffAt: json['droppedOffAt'] != null
          ? DateTime.tryParse(json['droppedOffAt'].toString())
          : null,
      accountHolderOnBoard: readBool(json['accountHolderOnBoard']),
      accountHolderDroppedOffAt: json['accountHolderDroppedOffAt'] != null
          ? DateTime.tryParse(json['accountHolderDroppedOffAt'].toString())
          : null,
      leftAt: json['leftAt'] != null
          ? DateTime.tryParse(json['leftAt'].toString())
          : null,
      canceledAt: json['canceledAt'] != null
          ? DateTime.tryParse(json['canceledAt'].toString())
          : null,
      removedAt: json['removedAt'] != null
          ? DateTime.tryParse(json['removedAt'].toString())
          : null,
      removeReason: json['removeReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sharedRideId': sharedRideId,
      'riderProfileId': riderProfileId,
      if (riderName != null) 'riderName': riderName,
      'status': status,
      'paymentStatus': paymentStatus,
      'seatsNeeded': seatsNeeded,
      'activeSeats': activeSeats,
      'totalPaidFare': totalPaidFare,
      if (finalDistanceKm != null) 'finalDistanceKm': finalDistanceKm,
      if (finalDurationSec != null) 'finalDurationSec': finalDurationSec,
      if (finalFare != null) 'finalFare': finalFare,
      'joinedAt': joinedAt.toIso8601String(),
      if (onBoardAt != null) 'onBoardAt': onBoardAt!.toIso8601String(),
      if (droppedOffAt != null) 'droppedOffAt': droppedOffAt!.toIso8601String(),
      'accountHolderOnBoard': accountHolderOnBoard,
      if (accountHolderDroppedOffAt != null)
        'accountHolderDroppedOffAt': accountHolderDroppedOffAt!
            .toIso8601String(),
      if (leftAt != null) 'leftAt': leftAt!.toIso8601String(),
      if (canceledAt != null) 'canceledAt': canceledAt!.toIso8601String(),
      if (removedAt != null) 'removedAt': removedAt!.toIso8601String(),
      if (removeReason != null) 'removeReason': removeReason,
    };
  }

  SharedRidePassengerEntity toEntity() {
    return SharedRidePassengerEntity(
      id: id,
      sharedRideId: sharedRideId,
      riderProfileId: riderProfileId,
      riderName: riderName,
      status: status,
      paymentStatus: paymentStatus,
      seatsNeeded: seatsNeeded,
      activeSeats: activeSeats,
      totalPaidFare: totalPaidFare,
      finalDistanceKm: finalDistanceKm,
      finalDurationSec: finalDurationSec,
      finalFare: finalFare,
      joinedAt: joinedAt,
      onBoardAt: onBoardAt,
      droppedOffAt: droppedOffAt,
      accountHolderOnBoard: accountHolderOnBoard,
      accountHolderDroppedOffAt: accountHolderDroppedOffAt,
      leftAt: leftAt,
      canceledAt: canceledAt,
      removedAt: removedAt,
      removeReason: removeReason,
    );
  }
}
