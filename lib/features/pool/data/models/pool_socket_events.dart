import 'package:equatable/equatable.dart';
import '../../domain/entities/pool_member_entity.dart';
import 'pool_member_model.dart';

class PoolMemberJoinedPayload extends Equatable {
  final int roomId;
  final int currentPassengers;
  final double? meetingLat;
  final double? meetingLng;
  final String? meetingAddress;
  final PoolMemberEntity? member;

  const PoolMemberJoinedPayload({
    required this.roomId,
    required this.currentPassengers,
    this.meetingLat,
    this.meetingLng,
    this.meetingAddress,
    this.member,
  });

  factory PoolMemberJoinedPayload.fromJson(Map<String, dynamic> json) {
    return PoolMemberJoinedPayload(
      roomId: json['roomId'] is int
          ? json['roomId']
          : int.tryParse('${json['roomId']}') ?? 0,
      currentPassengers: json['currentPassengers'] is int
          ? json['currentPassengers']
          : int.tryParse('${json['currentPassengers']}') ?? 1,
      meetingLat: json['meetingLat'] != null
          ? (json['meetingLat'] is num
                    ? json['meetingLat']
                    : double.tryParse('${json['meetingLat']}'))
                ?.toDouble()
          : null,
      meetingLng: json['meetingLng'] != null
          ? (json['meetingLng'] is num
                    ? json['meetingLng']
                    : double.tryParse('${json['meetingLng']}'))
                ?.toDouble()
          : null,
      meetingAddress: json['meetingAddress'] as String?,
      member: json['member'] is Map<String, dynamic>
          ? PoolMemberModel.fromJson(
              json['member'] as Map<String, dynamic>,
            ).toEntity()
          : null,
    );
  }

  @override
  List<Object?> get props => [
    roomId,
    currentPassengers,
    meetingLat,
    meetingLng,
    meetingAddress,
    member,
  ];
}

class PoolMemberLeftPayload extends Equatable {
  final int roomId;
  final int currentPassengers;
  final int? riderProfileId;
  final double? meetingLat;
  final double? meetingLng;
  final String? meetingAddress;

  const PoolMemberLeftPayload({
    required this.roomId,
    required this.currentPassengers,
    this.riderProfileId,
    this.meetingLat,
    this.meetingLng,
    this.meetingAddress,
  });

  factory PoolMemberLeftPayload.fromJson(Map<String, dynamic> json) {
    return PoolMemberLeftPayload(
      roomId: json['roomId'] is int
          ? json['roomId']
          : int.tryParse('${json['roomId']}') ?? 0,
      currentPassengers: json['currentPassengers'] is int
          ? json['currentPassengers']
          : int.tryParse('${json['currentPassengers']}') ?? 0,
      riderProfileId: json['riderProfileId'] is int
          ? json['riderProfileId']
          : int.tryParse('${json['riderProfileId']}'),
      meetingLat: json['meetingLat'] != null
          ? (json['meetingLat'] is num
                    ? json['meetingLat']
                    : double.tryParse('${json['meetingLat']}'))
                ?.toDouble()
          : null,
      meetingLng: json['meetingLng'] != null
          ? (json['meetingLng'] is num
                    ? json['meetingLng']
                    : double.tryParse('${json['meetingLng']}'))
                ?.toDouble()
          : null,
      meetingAddress: json['meetingAddress'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    roomId,
    currentPassengers,
    riderProfileId,
    meetingLat,
    meetingLng,
    meetingAddress,
  ];
}

class PoolMeetingPointUpdatedPayload extends Equatable {
  final int roomId;
  final double meetingLat;
  final double meetingLng;
  final String? meetingAddress;

  const PoolMeetingPointUpdatedPayload({
    required this.roomId,
    required this.meetingLat,
    required this.meetingLng,
    this.meetingAddress,
  });

  factory PoolMeetingPointUpdatedPayload.fromJson(Map<String, dynamic> json) {
    return PoolMeetingPointUpdatedPayload(
      roomId: json['roomId'] is int
          ? json['roomId']
          : int.tryParse('${json['roomId']}') ?? 0,
      meetingLat:
          (json['meetingLat'] is num
                  ? json['meetingLat']
                  : double.tryParse('${json['meetingLat']}'))
              ?.toDouble(),
      meetingLng:
          (json['meetingLng'] is num
                  ? json['meetingLng']
                  : double.tryParse('${json['meetingLng']}'))
              ?.toDouble(),
      meetingAddress: json['meetingAddress'] as String?,
    );
  }

  @override
  List<Object?> get props => [roomId, meetingLat, meetingLng, meetingAddress];
}

class PoolRoomReadyPayload extends Equatable {
  final int roomId;
  final String status;
  final int currentPassengers;

  const PoolRoomReadyPayload({
    required this.roomId,
    required this.status,
    required this.currentPassengers,
  });

  factory PoolRoomReadyPayload.fromJson(Map<String, dynamic> json) {
    return PoolRoomReadyPayload(
      roomId: json['roomId'] is int
          ? json['roomId']
          : int.tryParse('${json['roomId']}') ?? 0,
      status: json['status'] as String? ?? 'READY_FOR_DRIVER',
      currentPassengers: json['currentPassengers'] is int
          ? json['currentPassengers']
          : int.tryParse('${json['currentPassengers']}') ?? 0,
    );
  }

  @override
  List<Object?> get props => [roomId, status, currentPassengers];
}

class PoolMatchedPayload extends Equatable {
  final int roomId;
  final int sharedRideId;
  final int? driverProfileId;

  const PoolMatchedPayload({
    required this.roomId,
    required this.sharedRideId,
    this.driverProfileId,
  });

  factory PoolMatchedPayload.fromJson(Map<String, dynamic> json) {
    return PoolMatchedPayload(
      roomId: json['roomId'] is int
          ? json['roomId']
          : int.tryParse('${json['roomId']}') ?? 0,
      sharedRideId: json['sharedRideId'] is int
          ? json['sharedRideId']
          : int.tryParse('${json['sharedRideId']}') ?? 0,
      driverProfileId: json['driverProfileId'] is int
          ? json['driverProfileId']
          : int.tryParse('${json['driverProfileId']}'),
    );
  }

  @override
  List<Object?> get props => [roomId, sharedRideId, driverProfileId];
}

class PoolExpiredPayload extends Equatable {
  final int roomId;

  const PoolExpiredPayload({required this.roomId});

  factory PoolExpiredPayload.fromJson(Map<String, dynamic> json) {
    return PoolExpiredPayload(
      roomId: json['roomId'] is int
          ? json['roomId']
          : int.tryParse('${json['roomId']}') ?? 0,
    );
  }

  @override
  List<Object?> get props => [roomId];
}

class PoolCancelledPayload extends Equatable {
  final int roomId;

  const PoolCancelledPayload({required this.roomId});

  factory PoolCancelledPayload.fromJson(Map<String, dynamic> json) {
    return PoolCancelledPayload(
      roomId: json['roomId'] is int
          ? json['roomId']
          : int.tryParse('${json['roomId']}') ?? 0,
    );
  }

  @override
  List<Object?> get props => [roomId];
}

class PoolRemovedPayload extends Equatable {
  final int roomId;

  const PoolRemovedPayload({required this.roomId});

  factory PoolRemovedPayload.fromJson(Map<String, dynamic> json) {
    return PoolRemovedPayload(
      roomId: json['roomId'] is int
          ? json['roomId']
          : int.tryParse('${json['roomId']}') ?? 0,
    );
  }

  @override
  List<Object?> get props => [roomId];
}
