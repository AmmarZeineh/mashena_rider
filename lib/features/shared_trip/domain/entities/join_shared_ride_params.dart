/// Parameters for joining an open Shared Ride room.
class JoinSharedRideParams {
  final int roomId;
  final int seatsNeeded;

  const JoinSharedRideParams({required this.roomId, this.seatsNeeded = 1});

  Map<String, dynamic> toJson() {
    return {'seatsNeeded': seatsNeeded};
  }

  JoinSharedRideParams copyWith({int? roomId, int? seatsNeeded}) {
    return JoinSharedRideParams(
      roomId: roomId ?? this.roomId,
      seatsNeeded: seatsNeeded ?? this.seatsNeeded,
    );
  }
}
