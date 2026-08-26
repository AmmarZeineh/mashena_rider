import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/features/pool/data/models/pool_member_model.dart';
import 'package:mashena_rider/features/pool/data/models/pool_room_model.dart';
import 'package:mashena_rider/features/pool/data/models/pool_socket_events.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_room_status.dart';
import 'package:mashena_rider/features/pool/domain/entities/pool_suggestion_params.dart';

void main() {
  group('PoolSuggestionParams', () {
    test('toQueryMap creates valid map with all fields', () {
      final departure = DateTime.parse('2026-08-25T10:00:00.000Z');
      final params = PoolSuggestionParams(
        pickupLat: 36.2021,
        pickupLng: 37.1343,
        destinationLat: 36.2121,
        destinationLng: 37.1443,
        departureTime: departure,
      );

      final map = params.toQueryMap();
      expect(map['pickupLat'], 36.2021);
      expect(map['pickupLng'], 37.1343);
      expect(map['destinationLat'], 36.2121);
      expect(map['destinationLng'], 37.1443);
      expect(map['departureTime'], departure.toIso8601String());
    });
  });

  group('PoolMemberModel', () {
    final sampleMemberJson = <String, dynamic>{
      'id': 20,
      'roomId': 12,
      'riderProfileId': 5,
      'seatsNeeded': 1,
      'status': 'JOINED',
      'pickupLat': 36.2021,
      'pickupLng': 37.1343,
      'pickupAddress': 'Near Park Entrance',
      'joinedAt': '2026-08-25T08:30:00.000Z',
      'rider': {
        'fullName': 'Ammar Zeineh',
        'avatarUrl': 'https://example.com/avatar.jpg',
        'phoneNumber': '+963999999999',
      },
    };

    test('fromJson parses correctly', () {
      final model = PoolMemberModel.fromJson(sampleMemberJson);
      expect(model.id, 20);
      expect(model.roomId, 12);
      expect(model.riderProfileId, 5);
      expect(model.seatsNeeded, 1);
      expect(model.status, 'JOINED');
      expect(model.riderName, 'Ammar Zeineh');
      expect(model.riderAvatarUrl, 'https://example.com/avatar.jpg');
    });

    test('toEntity maps all properties', () {
      final model = PoolMemberModel.fromJson(sampleMemberJson);
      final entity = model.toEntity();
      expect(entity.id, 20);
      expect(entity.isJoined, isTrue);
      expect(entity.riderName, 'Ammar Zeineh');
    });
  });

  group('PoolRoomModel', () {
    final sampleRoomJson = <String, dynamic>{
      'id': 12,
      'creatorRiderProfileId': 5,
      'status': 'OPEN',
      'meetingLat': 36.2021,
      'meetingLng': 37.1343,
      'meetingAddress': 'Near Park Entrance',
      'destinationLat': 36.2121,
      'destinationLng': 37.1443,
      'destinationAddress': 'Aleppo University',
      'maxPassengers': 4,
      'currentPassengers': 1,
      'departureTime': '2026-08-25T10:00:00.000Z',
      'expiresAt': '2026-08-25T09:45:00.000Z',
      'members': [
        {
          'id': 20,
          'roomId': 12,
          'riderProfileId': 5,
          'seatsNeeded': 1,
          'status': 'JOINED',
          'pickupLat': 36.2021,
          'pickupLng': 37.1343,
          'pickupAddress': 'Near Park Entrance',
          'joinedAt': '2026-08-25T08:30:00.000Z',
        },
      ],
    };

    test('fromJson parses room and members correctly', () {
      final model = PoolRoomModel.fromJson(sampleRoomJson);
      expect(model.id, 12);
      expect(model.creatorRiderProfileId, 5);
      expect(model.status, 'OPEN');
      expect(model.maxPassengers, 4);
      expect(model.currentPassengers, 1);
      expect(model.members.length, 1);
    });

    test('toEntity converts status to PoolRoomStatus enum', () {
      final model = PoolRoomModel.fromJson(sampleRoomJson);
      final entity = model.toEntity();
      expect(entity.status, PoolRoomStatus.open);
      expect(entity.isFull, isFalse);
      expect(entity.availableSeats, 3);
      expect(entity.isCreator(5), isTrue);
      expect(entity.isCreator(99), isFalse);
    });
  });

  group('PoolSocketEvents', () {
    test('PoolMemberJoinedPayload parses json correctly', () {
      final json = <String, dynamic>{
        'roomId': 12,
        'currentPassengers': 3,
        'meetingLat': 36.203,
        'meetingLng': 37.136,
        'meetingAddress': 'Main Square',
      };
      final payload = PoolMemberJoinedPayload.fromJson(json);
      expect(payload.roomId, 12);
      expect(payload.currentPassengers, 3);
      expect(payload.meetingLat, 36.203);
      expect(payload.meetingAddress, 'Main Square');
    });

    test('PoolMatchedPayload parses sharedRideId', () {
      final json = <String, dynamic>{
        'roomId': 12,
        'sharedRideId': 45,
        'driverProfileId': 8,
      };
      final payload = PoolMatchedPayload.fromJson(json);
      expect(payload.roomId, 12);
      expect(payload.sharedRideId, 45);
      expect(payload.driverProfileId, 8);
    });
  });
}
