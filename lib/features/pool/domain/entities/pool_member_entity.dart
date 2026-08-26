import 'package:equatable/equatable.dart';

class PoolMemberEntity extends Equatable {
  final int id;
  final int roomId;
  final int riderProfileId;
  final int seatsNeeded;
  final String status;
  final double pickupLat;
  final double pickupLng;
  final String? pickupAddress;
  final DateTime? joinedAt;
  final DateTime? leftAt;
  final String? riderName;
  final String? riderAvatarUrl;
  final String? riderPhoneNumber;

  const PoolMemberEntity({
    required this.id,
    required this.roomId,
    required this.riderProfileId,
    required this.seatsNeeded,
    required this.status,
    required this.pickupLat,
    required this.pickupLng,
    this.pickupAddress,
    this.joinedAt,
    this.leftAt,
    this.riderName,
    this.riderAvatarUrl,
    this.riderPhoneNumber,
  });

  bool get isJoined => status.toUpperCase() == 'JOINED';

  @override
  List<Object?> get props => [
    id,
    roomId,
    riderProfileId,
    seatsNeeded,
    status,
    pickupLat,
    pickupLng,
    pickupAddress,
    joinedAt,
    leftAt,
    riderName,
    riderAvatarUrl,
    riderPhoneNumber,
  ];
}
