import '../../domain/entities/pool_member_entity.dart';

class PoolMemberModel {
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

  const PoolMemberModel({
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

  factory PoolMemberModel.fromJson(Map<String, dynamic> json) {
    String? name;
    String? avatar;
    String? phone;

    if (json['rider'] is Map<String, dynamic>) {
      final riderMap = json['rider'] as Map<String, dynamic>;
      name = riderMap['fullName'] as String? ?? riderMap['name'] as String?;
      avatar =
          riderMap['avatarUrl'] as String? ?? riderMap['avatar'] as String?;
      phone =
          riderMap['phoneNumber'] as String? ?? riderMap['phone'] as String?;
    } else if (json['riderProfile'] is Map<String, dynamic>) {
      final riderMap = json['riderProfile'] as Map<String, dynamic>;
      name = riderMap['fullName'] as String? ?? riderMap['name'] as String?;
      avatar =
          riderMap['avatarUrl'] as String? ?? riderMap['avatar'] as String?;
      phone =
          riderMap['phoneNumber'] as String? ?? riderMap['phone'] as String?;
    }

    return PoolMemberModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      roomId: json['roomId'] is int
          ? json['roomId']
          : int.tryParse('${json['roomId']}') ?? 0,
      riderProfileId: json['riderProfileId'] is int
          ? json['riderProfileId']
          : int.tryParse('${json['riderProfileId']}') ?? 0,
      seatsNeeded: json['seatsNeeded'] is int
          ? json['seatsNeeded']
          : int.tryParse('${json['seatsNeeded']}') ?? 1,
      status: json['status'] as String? ?? 'JOINED',
      pickupLat:
          (json['pickupLat'] is num
                  ? json['pickupLat']
                  : double.tryParse('${json['pickupLat']}'))
              ?.toDouble() ??
          0.0,
      pickupLng:
          (json['pickupLng'] is num
                  ? json['pickupLng']
                  : double.tryParse('${json['pickupLng']}'))
              ?.toDouble() ??
          0.0,
      pickupAddress: json['pickupAddress'] as String?,
      joinedAt: json['joinedAt'] != null
          ? DateTime.tryParse('${json['joinedAt']}')
          : null,
      leftAt: json['leftAt'] != null
          ? DateTime.tryParse('${json['leftAt']}')
          : null,
      riderName: name,
      riderAvatarUrl: avatar,
      riderPhoneNumber: phone,
    );
  }

  PoolMemberEntity toEntity() {
    return PoolMemberEntity(
      id: id,
      roomId: roomId,
      riderProfileId: riderProfileId,
      seatsNeeded: seatsNeeded,
      status: status,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      pickupAddress: pickupAddress,
      joinedAt: joinedAt,
      leftAt: leftAt,
      riderName: riderName,
      riderAvatarUrl: riderAvatarUrl,
      riderPhoneNumber: riderPhoneNumber,
    );
  }
}
