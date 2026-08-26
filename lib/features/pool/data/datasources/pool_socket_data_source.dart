import 'dart:async';
import 'package:mashena_rider/core/network/socket_client.dart';
import 'package:mashena_rider/core/services/logger_service.dart';
import '../models/pool_socket_events.dart';

abstract interface class PoolSocketDataSource {
  Stream<PoolMemberJoinedPayload> get memberJoinedStream;
  Stream<PoolMemberLeftPayload> get memberLeftStream;
  Stream<PoolMeetingPointUpdatedPayload> get meetingPointUpdatedStream;
  Stream<PoolRoomReadyPayload> get roomReadyStream;
  Stream<PoolMatchedPayload> get matchedStream;
  Stream<PoolExpiredPayload> get expiredStream;
  Stream<PoolCancelledPayload> get cancelledStream;
  Stream<PoolRemovedPayload> get removedStream;

  Future<void> connectSocket();
  void listenToRoom(int roomId);
  void stopListeningToRoom(int roomId);
  Future<void> dispose();
}

class PoolSocketDataSourceImpl implements PoolSocketDataSource {
  final SocketClient _socketClient;

  final Set<int> _activeRooms = {};
  StreamSubscription<bool>? _connectionSubscription;

  final _memberJoinedController =
      StreamController<PoolMemberJoinedPayload>.broadcast();
  final _memberLeftController =
      StreamController<PoolMemberLeftPayload>.broadcast();
  final _meetingPointUpdatedController =
      StreamController<PoolMeetingPointUpdatedPayload>.broadcast();
  final _roomReadyController =
      StreamController<PoolRoomReadyPayload>.broadcast();
  final _matchedController = StreamController<PoolMatchedPayload>.broadcast();
  final _expiredController = StreamController<PoolExpiredPayload>.broadcast();
  final _cancelledController =
      StreamController<PoolCancelledPayload>.broadcast();
  final _removedController = StreamController<PoolRemovedPayload>.broadcast();

  // Callbacks references for clean unregistration
  late final void Function(dynamic) _onMemberJoined;
  late final void Function(dynamic) _onMemberLeft;
  late final void Function(dynamic) _onMeetingPointUpdated;
  late final void Function(dynamic) _onRoomReady;
  late final void Function(dynamic) _onMatched;
  late final void Function(dynamic) _onExpired;
  late final void Function(dynamic) _onCancelled;
  late final void Function(dynamic) _onRemoved;

  PoolSocketDataSourceImpl(this._socketClient) {
    _initSocketListeners();
    _initReconnectionHandler();
  }

  void _initReconnectionHandler() {
    _connectionSubscription = _socketClient.connectionStatusStream.listen((
      connected,
    ) {
      if (connected && _activeRooms.isNotEmpty) {
        for (final roomId in _activeRooms) {
          LoggerService.debug(
            'Re-joining passenger pool room after socket reconnect: passenger-pool:$roomId',
            name: 'features.pool.socket',
          );
          _socketClient.emit('join_pool_room', roomId);
        }
      }
    });
  }

  void _initSocketListeners() {
    _onMemberJoined = (data) {
      LoggerService.debug(
        'Received pool:member_joined event: $data',
        name: 'features.pool.socket',
      );
      try {
        if (data is Map && !_memberJoinedController.isClosed) {
          _memberJoinedController.add(
            PoolMemberJoinedPayload.fromJson(Map<String, dynamic>.from(data)),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing pool:member_joined payload',
          name: 'features.pool.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('pool:member_joined', _onMemberJoined);

    _onMemberLeft = (data) {
      LoggerService.debug(
        'Received pool:member_left event: $data',
        name: 'features.pool.socket',
      );
      try {
        if (data is Map && !_memberLeftController.isClosed) {
          _memberLeftController.add(
            PoolMemberLeftPayload.fromJson(Map<String, dynamic>.from(data)),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing pool:member_left payload',
          name: 'features.pool.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('pool:member_left', _onMemberLeft);

    _onMeetingPointUpdated = (data) {
      LoggerService.debug(
        'Received pool:meeting_point_updated event: $data',
        name: 'features.pool.socket',
      );
      try {
        if (data is Map && !_meetingPointUpdatedController.isClosed) {
          _meetingPointUpdatedController.add(
            PoolMeetingPointUpdatedPayload.fromJson(
              Map<String, dynamic>.from(data),
            ),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing pool:meeting_point_updated payload',
          name: 'features.pool.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('pool:meeting_point_updated', _onMeetingPointUpdated);

    _onRoomReady = (data) {
      LoggerService.debug(
        'Received pool:room_ready event: $data',
        name: 'features.pool.socket',
      );
      try {
        if (data is Map && !_roomReadyController.isClosed) {
          _roomReadyController.add(
            PoolRoomReadyPayload.fromJson(Map<String, dynamic>.from(data)),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing pool:room_ready payload',
          name: 'features.pool.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('pool:room_ready', _onRoomReady);

    _onMatched = (data) {
      LoggerService.debug(
        'Received pool:matched event: $data',
        name: 'features.pool.socket',
      );
      try {
        if (data is Map && !_matchedController.isClosed) {
          _matchedController.add(
            PoolMatchedPayload.fromJson(Map<String, dynamic>.from(data)),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing pool:matched payload',
          name: 'features.pool.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('pool:matched', _onMatched);

    _onExpired = (data) {
      LoggerService.debug(
        'Received pool:expired event: $data',
        name: 'features.pool.socket',
      );
      try {
        if (data is Map && !_expiredController.isClosed) {
          _expiredController.add(
            PoolExpiredPayload.fromJson(Map<String, dynamic>.from(data)),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing pool:expired payload',
          name: 'features.pool.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('pool:expired', _onExpired);

    _onCancelled = (data) {
      LoggerService.debug(
        'Received pool:cancelled event: $data',
        name: 'features.pool.socket',
      );
      try {
        if (data is Map && !_cancelledController.isClosed) {
          _cancelledController.add(
            PoolCancelledPayload.fromJson(Map<String, dynamic>.from(data)),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing pool:cancelled payload',
          name: 'features.pool.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('pool:cancelled', _onCancelled);

    _onRemoved = (data) {
      LoggerService.debug(
        'Received pool:removed event: $data',
        name: 'features.pool.socket',
      );
      try {
        if (data is Map && !_removedController.isClosed) {
          _removedController.add(
            PoolRemovedPayload.fromJson(Map<String, dynamic>.from(data)),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing pool:removed payload',
          name: 'features.pool.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('pool:removed', _onRemoved);
  }

  @override
  Stream<PoolMemberJoinedPayload> get memberJoinedStream =>
      _memberJoinedController.stream;

  @override
  Stream<PoolMemberLeftPayload> get memberLeftStream =>
      _memberLeftController.stream;

  @override
  Stream<PoolMeetingPointUpdatedPayload> get meetingPointUpdatedStream =>
      _meetingPointUpdatedController.stream;

  @override
  Stream<PoolRoomReadyPayload> get roomReadyStream =>
      _roomReadyController.stream;

  @override
  Stream<PoolMatchedPayload> get matchedStream => _matchedController.stream;

  @override
  Stream<PoolExpiredPayload> get expiredStream => _expiredController.stream;

  @override
  Stream<PoolCancelledPayload> get cancelledStream =>
      _cancelledController.stream;

  @override
  Stream<PoolRemovedPayload> get removedStream => _removedController.stream;

  @override
  Future<void> connectSocket() => _socketClient.connect();

  @override
  void listenToRoom(int roomId) {
    _activeRooms.add(roomId);
    LoggerService.debug(
      'Listening to passenger pool room: passenger-pool:$roomId',
      name: 'features.pool.socket',
    );
    _socketClient.emit('join_pool_room', roomId);
  }

  @override
  void stopListeningToRoom(int roomId) {
    _activeRooms.remove(roomId);
    LoggerService.debug(
      'Stopped listening to passenger pool room: passenger-pool:$roomId',
      name: 'features.pool.socket',
    );
    _socketClient.emit('leave_pool_room', roomId);
  }

  @override
  Future<void> dispose() async {
    await _connectionSubscription?.cancel();
    _connectionSubscription = null;
    _activeRooms.clear();

    // Cleanly unregister callbacks from socket client
    _socketClient.off('pool:member_joined', _onMemberJoined);
    _socketClient.off('pool:member_left', _onMemberLeft);
    _socketClient.off('pool:meeting_point_updated', _onMeetingPointUpdated);
    _socketClient.off('pool:room_ready', _onRoomReady);
    _socketClient.off('pool:matched', _onMatched);
    _socketClient.off('pool:expired', _onExpired);
    _socketClient.off('pool:cancelled', _onCancelled);
    _socketClient.off('pool:removed', _onRemoved);

    if (!_memberJoinedController.isClosed) {
      await _memberJoinedController.close();
    }
    if (!_memberLeftController.isClosed) {
      await _memberLeftController.close();
    }
    if (!_meetingPointUpdatedController.isClosed) {
      await _meetingPointUpdatedController.close();
    }
    if (!_roomReadyController.isClosed) {
      await _roomReadyController.close();
    }
    if (!_matchedController.isClosed) {
      await _matchedController.close();
    }
    if (!_expiredController.isClosed) {
      await _expiredController.close();
    }
    if (!_cancelledController.isClosed) {
      await _cancelledController.close();
    }
    if (!_removedController.isClosed) {
      await _removedController.close();
    }
  }
}
