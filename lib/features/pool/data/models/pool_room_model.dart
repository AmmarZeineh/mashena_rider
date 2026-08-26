import '../../domain/entities/pool_room_entity.dart';
import '../../domain/entities/pool_room_status.dart';
import 'pool_member_model.dart';

class PoolRoomModel {
  final int id;
  final int creatorRiderProfileId;
  final String status;
  final double meetingLat;
  final double meetingLng;
  final String? meetingAddress;
  final String? meetingPlaceName;
  final String? meetingPlaceProvider;
  final double destinationLat;
  final double destinationLng;
  final String? destinationAddress;
  final int maxPassengers;
  final int currentPassengers;
  final DateTime? departureTime;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? driverAcceptedAt;
  final List<PoolMemberModel> members;
  final int? sharedRideId;
  final int? driverProfileId;

  const PoolRoomModel({
    required this.id,
    required this.creatorRiderProfileId,
    required this.status,
    required this.meetingLat,
    required this.meetingLng,
    this.meetingAddress,
    this.meetingPlaceName,
    this.meetingPlaceProvider,
    required this.destinationLat,
    required this.destinationLng,
    this.destinationAddress,
    required this.maxPassengers,
    required this.currentPassengers,
    this.departureTime,
    this.expiresAt,
    this.createdAt,
    this.driverAcceptedAt,
    this.members = const [],
    this.sharedRideId,
    this.driverProfileId,
  });

  factory PoolRoomModel.fromJson(Map<String, dynamic> json) {
    List<PoolMemberModel> membersList = [];
    if (json['members'] is List) {
      membersList = (json['members'] as List)
          .whereType<Map<String, dynamic>>()
          .map((m) => PoolMemberModel.fromJson(m))
          .toList();
    }

    return PoolRoomModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      creatorRiderProfileId: json['creatorRiderProfileId'] is int
          ? json['creatorRiderProfileId']
          : int.tryParse('${json['creatorRiderProfileId']}') ?? 0,
      status: json['status'] as String? ?? 'OPEN',
      meetingLat:
          (json['meetingLat'] is num
                  ? json['meetingLat']
                  : double.tryParse('${json['meetingLat']}'))
              ?.toDouble() ??
          0.0,
      meetingLng:
          (json['meetingLng'] is num
                  ? json['meetingLng']
                  : double.tryParse('${json['meetingLng']}'))
              ?.toDouble() ??
          0.0,
      meetingAddress: json['meetingAddress'] as String?,
      meetingPlaceName: json['meetingPlaceName'] as String?,
      meetingPlaceProvider: json['meetingPlaceProvider'] as String?,
      destinationLat:
          (json['destinationLat'] is num
                  ? json['destinationLat']
                  : double.tryParse('${json['destinationLat']}'))
              ?.toDouble() ??
          0.0,
      destinationLng:
          (json['destinationLng'] is num
                  ? json['destinationLng']
                  : double.tryParse('${json['destinationLng']}'))
              ?.toDouble() ??
          0.0,
      destinationAddress: json['destinationAddress'] as String?,
      maxPassengers: json['maxPassengers'] is int
          ? json['maxPassengers']
          : int.tryParse('${json['maxPassengers']}') ?? 4,
      currentPassengers: json['currentPassengers'] is int
          ? json['currentPassengers']
          : int.tryParse('${json['currentPassengers']}') ??
                (membersList.isNotEmpty ? membersList.length : 1),
      departureTime: json['departureTime'] != null
          ? DateTime.tryParse('${json['departureTime']}')
          : null,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse('${json['expiresAt']}')
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse('${json['createdAt']}')
          : null,
      driverAcceptedAt: json['driverAcceptedAt'] != null
          ? DateTime.tryParse('${json['driverAcceptedAt']}')
          : null,
      members: membersList,
      sharedRideId: json['sharedRideId'] is int
          ? json['sharedRideId']
          : int.tryParse('${json['sharedRideId']}'),
      driverProfileId: json['driverProfileId'] is int
          ? json['driverProfileId']
          : int.tryParse('${json['driverProfileId']}'),
    );
  }

  PoolRoomEntity toEntity() {
    return PoolRoomEntity(
      id: id,
      creatorRiderProfileId: creatorRiderProfileId,
      status: PoolRoomStatus.fromString(status),
      meetingLat: meetingLat,
      meetingLng: meetingLng,
      meetingAddress: meetingAddress,
      meetingPlaceName: meetingPlaceName,
      meetingPlaceProvider: meetingPlaceProvider,
      destinationLat: destinationLat,
      destinationLng: destinationLng,
      destinationAddress: destinationAddress,
      maxPassengers: maxPassengers,
      currentPassengers: currentPassengers,
      departureTime: departureTime,
      expiresAt: expiresAt,
      createdAt: createdAt,
      driverAcceptedAt: driverAcceptedAt,
      members: members.map((m) => m.toEntity()).toList(),
      sharedRideId: sharedRideId,
      driverProfileId: driverProfileId,
    );
  }
}
