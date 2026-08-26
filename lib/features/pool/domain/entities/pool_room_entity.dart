import 'package:equatable/equatable.dart';
import 'pool_member_entity.dart';
import 'pool_room_status.dart';

class PoolRoomEntity extends Equatable {
  final int id;
  final int creatorRiderProfileId;
  final PoolRoomStatus status;
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
  final List<PoolMemberEntity> members;
  final int? sharedRideId;
  final int? driverProfileId;

  const PoolRoomEntity({
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

  bool get isFull => currentPassengers >= maxPassengers;
  int get availableSeats =>
      (maxPassengers - currentPassengers).clamp(0, maxPassengers);

  bool isCreator(int? currentProfileId) {
    if (currentProfileId == null) return false;
    return creatorRiderProfileId == currentProfileId;
  }

  bool isUserMember(int? currentProfileId) {
    if (currentProfileId == null) return false;
    return members.any(
      (m) => m.riderProfileId == currentProfileId && m.isJoined,
    );
  }

  PoolRoomEntity copyWith({
    int? id,
    int? creatorRiderProfileId,
    PoolRoomStatus? status,
    double? meetingLat,
    double? meetingLng,
    String? meetingAddress,
    String? meetingPlaceName,
    String? meetingPlaceProvider,
    double? destinationLat,
    double? destinationLng,
    String? destinationAddress,
    int? maxPassengers,
    int? currentPassengers,
    DateTime? departureTime,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? driverAcceptedAt,
    List<PoolMemberEntity>? members,
    int? sharedRideId,
    int? driverProfileId,
  }) {
    return PoolRoomEntity(
      id: id ?? this.id,
      creatorRiderProfileId:
          creatorRiderProfileId ?? this.creatorRiderProfileId,
      status: status ?? this.status,
      meetingLat: meetingLat ?? this.meetingLat,
      meetingLng: meetingLng ?? this.meetingLng,
      meetingAddress: meetingAddress ?? this.meetingAddress,
      meetingPlaceName: meetingPlaceName ?? this.meetingPlaceName,
      meetingPlaceProvider: meetingPlaceProvider ?? this.meetingPlaceProvider,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLng: destinationLng ?? this.destinationLng,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      maxPassengers: maxPassengers ?? this.maxPassengers,
      currentPassengers: currentPassengers ?? this.currentPassengers,
      departureTime: departureTime ?? this.departureTime,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      driverAcceptedAt: driverAcceptedAt ?? this.driverAcceptedAt,
      members: members ?? this.members,
      sharedRideId: sharedRideId ?? this.sharedRideId,
      driverProfileId: driverProfileId ?? this.driverProfileId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    creatorRiderProfileId,
    status,
    meetingLat,
    meetingLng,
    meetingAddress,
    meetingPlaceName,
    meetingPlaceProvider,
    destinationLat,
    destinationLng,
    destinationAddress,
    maxPassengers,
    currentPassengers,
    departureTime,
    expiresAt,
    createdAt,
    driverAcceptedAt,
    members,
    sharedRideId,
    driverProfileId,
  ];
}
