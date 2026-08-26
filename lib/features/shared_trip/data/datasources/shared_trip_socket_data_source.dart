import 'dart:async';
import 'package:mashena_rider/core/network/socket_client.dart';
import 'package:mashena_rider/core/services/logger_service.dart';
import '../models/shared_ride_socket_events.dart';

abstract interface class SharedTripSocketDataSource {
  Stream<SharedRideDriverLocationPayload> get driverLocationStream;
  Stream<SharedRidePassengerJoinedPayload> get passengerJoinedStream;
  Stream<SharedRidePassengerLeftPayload> get passengerLeftStream;
  Stream<SharedRidePassengerRemovedPayload> get passengerRemovedStream;
  Stream<SharedRideRemovedPayload> get riderRemovedStream;
  Stream<SharedRideRoomReadyPayload> get roomReadyStream;
  Stream<SharedRideTripStartedPayload> get tripStartedStream;
  Stream<SharedRidePassengerOnBoardPayload> get passengerOnBoardStream;
  Stream<SharedRidePassengerDroppedPayload> get passengerDroppedStream;
  Stream<SharedRideCompletedPayload> get tripCompletedStream;
  Stream<SharedRideCancelledPayload> get tripCancelledStream;
  Stream<SharedRidePresencePayload> get presenceStream;

  Future<void> connectSocket();
  void listenToRoom(int sharedRideId);
  void stopListeningToRoom(int sharedRideId);
  Future<void> dispose();
}

class SharedTripSocketDataSourceImpl implements SharedTripSocketDataSource {
  final SocketClient _socketClient;

  final Set<int> _activeRooms = {};
  StreamSubscription<bool>? _connectionSubscription;

  final _driverLocationController =
      StreamController<SharedRideDriverLocationPayload>.broadcast();
  final _passengerJoinedController =
      StreamController<SharedRidePassengerJoinedPayload>.broadcast();
  final _passengerLeftController =
      StreamController<SharedRidePassengerLeftPayload>.broadcast();
  final _passengerRemovedController =
      StreamController<SharedRidePassengerRemovedPayload>.broadcast();
  final _riderRemovedController =
      StreamController<SharedRideRemovedPayload>.broadcast();
  final _roomReadyController =
      StreamController<SharedRideRoomReadyPayload>.broadcast();
  final _tripStartedController =
      StreamController<SharedRideTripStartedPayload>.broadcast();
  final _passengerOnBoardController =
      StreamController<SharedRidePassengerOnBoardPayload>.broadcast();
  final _passengerDroppedController =
      StreamController<SharedRidePassengerDroppedPayload>.broadcast();
  final _tripCompletedController =
      StreamController<SharedRideCompletedPayload>.broadcast();
  final _tripCancelledController =
      StreamController<SharedRideCancelledPayload>.broadcast();
  final _presenceController =
      StreamController<SharedRidePresencePayload>.broadcast();

  // Callbacks references for clean unregistration
  late final void Function(dynamic) _onDriverLocation;
  late final void Function(dynamic) _onPassengerJoined;
  late final void Function(dynamic) _onPassengerLeft;
  late final void Function(dynamic) _onPassengerRemoved;
  late final void Function(dynamic) _onRiderRemoved;
  late final void Function(dynamic) _onRoomReady;
  late final void Function(dynamic) _onTripStarted;
  late final void Function(dynamic) _onPassengerOnBoard;
  late final void Function(dynamic) _onPassengerDropped;
  late final void Function(dynamic) _onTripCompleted;
  late final void Function(dynamic) _onTripCancelled;
  late final void Function(dynamic) _onDriverOnline;
  late final void Function(dynamic) _onDriverOffline;
  late final void Function(dynamic) _onPassengerOnline;
  late final void Function(dynamic) _onPassengerOffline;

  SharedTripSocketDataSourceImpl(this._socketClient) {
    _initSocketListeners();
    _initReconnectionHandler();
  }

  void _initReconnectionHandler() {
    _connectionSubscription = _socketClient.connectionStatusStream.listen((
      connected,
    ) {
      if (connected && _activeRooms.isNotEmpty) {
        for (final sharedRideId in _activeRooms) {
          LoggerService.debug(
            'Re-joining shared ride room after socket reconnect: shared-ride:$sharedRideId',
            name: 'features.shared_trip.socket',
          );
          _socketClient.emit('join_shared_ride_room', sharedRideId);
        }
      }
    });
  }

  void _initSocketListeners() {
    _onDriverLocation = (data) {
      LoggerService.debug(
        'Received shared_ride:driver_location event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (_driverLocationController.isClosed) return;
        if (data is Map<String, dynamic>) {
          _driverLocationController.add(
            SharedRideDriverLocationPayload.fromJson(data),
          );
        } else if (data is Map) {
          _driverLocationController.add(
            SharedRideDriverLocationPayload.fromJson(
              Map<String, dynamic>.from(data),
            ),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing shared_ride:driver_location payload',
          name: 'features.shared_trip.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('shared_ride:driver_location', _onDriverLocation);

    _onPassengerJoined = (data) {
      LoggerService.debug(
        'Received shared_ride:passenger_joined event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map && !_passengerJoinedController.isClosed) {
          _passengerJoinedController.add(
            SharedRidePassengerJoinedPayload.fromJson(
              Map<String, dynamic>.from(data),
            ),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing shared_ride:passenger_joined payload',
          name: 'features.shared_trip.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('shared_ride:passenger_joined', _onPassengerJoined);

    _onPassengerLeft = (data) {
      LoggerService.debug(
        'Received shared_ride:passenger_left event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map && !_passengerLeftController.isClosed) {
          _passengerLeftController.add(
            SharedRidePassengerLeftPayload.fromJson(
              Map<String, dynamic>.from(data),
            ),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing shared_ride:passenger_left payload',
          name: 'features.shared_trip.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('shared_ride:passenger_left', _onPassengerLeft);

    _onPassengerRemoved = (data) {
      LoggerService.debug(
        'Received shared_ride:passenger_removed event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map && !_passengerRemovedController.isClosed) {
          _passengerRemovedController.add(
            SharedRidePassengerRemovedPayload.fromJson(
              Map<String, dynamic>.from(data),
            ),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing shared_ride:passenger_removed payload',
          name: 'features.shared_trip.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('shared_ride:passenger_removed', _onPassengerRemoved);

    _onRiderRemoved = (data) {
      LoggerService.debug(
        'Received shared_ride:removed event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map && !_riderRemovedController.isClosed) {
          _riderRemovedController.add(
            SharedRideRemovedPayload.fromJson(Map<String, dynamic>.from(data)),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing shared_ride:removed payload',
          name: 'features.shared_trip.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('shared_ride:removed', _onRiderRemoved);

    _onRoomReady = (data) {
      LoggerService.debug(
        'Received shared_ride:room_ready event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map && !_roomReadyController.isClosed) {
          _roomReadyController.add(
            SharedRideRoomReadyPayload.fromJson(
              Map<String, dynamic>.from(data),
            ),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing shared_ride:room_ready payload',
          name: 'features.shared_trip.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('shared_ride:room_ready', _onRoomReady);

    _onTripStarted = (data) {
      LoggerService.debug(
        'Received shared_ride:trip_started event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map && !_tripStartedController.isClosed) {
          _tripStartedController.add(
            SharedRideTripStartedPayload.fromJson(
              Map<String, dynamic>.from(data),
            ),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing shared_ride:trip_started payload',
          name: 'features.shared_trip.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('shared_ride:trip_started', _onTripStarted);

    _onPassengerOnBoard = (data) {
      LoggerService.debug(
        'Received shared_ride:passenger_on_board event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map && !_passengerOnBoardController.isClosed) {
          _passengerOnBoardController.add(
            SharedRidePassengerOnBoardPayload.fromJson(
              Map<String, dynamic>.from(data),
            ),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing shared_ride:passenger_on_board payload',
          name: 'features.shared_trip.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('shared_ride:passenger_on_board', _onPassengerOnBoard);

    _onPassengerDropped = (data) {
      LoggerService.debug(
        'Received shared_ride:passenger_dropped event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map && !_passengerDroppedController.isClosed) {
          _passengerDroppedController.add(
            SharedRidePassengerDroppedPayload.fromJson(
              Map<String, dynamic>.from(data),
            ),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing shared_ride:passenger_dropped payload',
          name: 'features.shared_trip.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('shared_ride:passenger_dropped', _onPassengerDropped);

    _onTripCompleted = (data) {
      LoggerService.debug(
        'Received shared_ride:completed event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map && !_tripCompletedController.isClosed) {
          _tripCompletedController.add(
            SharedRideCompletedPayload.fromJson(
              Map<String, dynamic>.from(data),
            ),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing shared_ride:completed payload',
          name: 'features.shared_trip.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('shared_ride:completed', _onTripCompleted);

    _onTripCancelled = (data) {
      LoggerService.debug(
        'Received shared_ride:cancelled event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map && !_tripCancelledController.isClosed) {
          _tripCancelledController.add(
            SharedRideCancelledPayload.fromJson(
              Map<String, dynamic>.from(data),
            ),
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing shared_ride:cancelled payload',
          name: 'features.shared_trip.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('shared_ride:cancelled', _onTripCancelled);

    // Presence listeners
    _onDriverOnline = (data) =>
        _handlePresence(data, isOnline: true, isDriver: true);
    _onDriverOffline = (data) =>
        _handlePresence(data, isOnline: false, isDriver: true);
    _onPassengerOnline = (data) =>
        _handlePresence(data, isOnline: true, isDriver: false);
    _onPassengerOffline = (data) =>
        _handlePresence(data, isOnline: false, isDriver: false);

    _socketClient.on('shared_ride:driver_online', _onDriverOnline);
    _socketClient.on('shared_ride:driver_offline', _onDriverOffline);
    _socketClient.on('shared_ride:passenger_online', _onPassengerOnline);
    _socketClient.on('shared_ride:passenger_offline', _onPassengerOffline);
  }

  void _handlePresence(
    dynamic data, {
    required bool isOnline,
    required bool isDriver,
  }) {
    LoggerService.debug(
      'Received presence event: $data (isOnline: $isOnline, isDriver: $isDriver)',
      name: 'features.shared_trip.socket',
    );
    try {
      if (data is Map && !_presenceController.isClosed) {
        _presenceController.add(
          SharedRidePresencePayload.fromJson(
            Map<String, dynamic>.from(data),
            isOnline: isOnline,
            isDriver: isDriver,
          ),
        );
      }
    } catch (e, stackTrace) {
      LoggerService.debug(
        'Error parsing presence payload',
        name: 'features.shared_trip.socket',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Stream<SharedRideDriverLocationPayload> get driverLocationStream =>
      _driverLocationController.stream;

  @override
  Stream<SharedRidePassengerJoinedPayload> get passengerJoinedStream =>
      _passengerJoinedController.stream;

  @override
  Stream<SharedRidePassengerLeftPayload> get passengerLeftStream =>
      _passengerLeftController.stream;

  @override
  Stream<SharedRidePassengerRemovedPayload> get passengerRemovedStream =>
      _passengerRemovedController.stream;

  @override
  Stream<SharedRideRemovedPayload> get riderRemovedStream =>
      _riderRemovedController.stream;

  @override
  Stream<SharedRideRoomReadyPayload> get roomReadyStream =>
      _roomReadyController.stream;

  @override
  Stream<SharedRideTripStartedPayload> get tripStartedStream =>
      _tripStartedController.stream;

  @override
  Stream<SharedRidePassengerOnBoardPayload> get passengerOnBoardStream =>
      _passengerOnBoardController.stream;

  @override
  Stream<SharedRidePassengerDroppedPayload> get passengerDroppedStream =>
      _passengerDroppedController.stream;

  @override
  Stream<SharedRideCompletedPayload> get tripCompletedStream =>
      _tripCompletedController.stream;

  @override
  Stream<SharedRideCancelledPayload> get tripCancelledStream =>
      _tripCancelledController.stream;

  @override
  Stream<SharedRidePresencePayload> get presenceStream =>
      _presenceController.stream;

  @override
  Future<void> connectSocket() => _socketClient.connect();

  @override
  void listenToRoom(int sharedRideId) {
    _activeRooms.add(sharedRideId);
    LoggerService.debug(
      'Tracking shared ride room $sharedRideId',
      name: 'features.shared_trip.socket',
    );
    _socketClient.emit('join_shared_ride_room', sharedRideId);
  }

  @override
  void stopListeningToRoom(int sharedRideId) {
    _activeRooms.remove(sharedRideId);
    LoggerService.debug(
      'Stopped tracking shared ride room $sharedRideId',
      name: 'features.shared_trip.socket',
    );
    _socketClient.emit('leave_shared_ride_room', sharedRideId);
  }

  @override
  Future<void> dispose() async {
    await _connectionSubscription?.cancel();
    _connectionSubscription = null;
    _activeRooms.clear();

    // Cleanly unregister callbacks from socket client
    _socketClient.off('shared_ride:driver_location', _onDriverLocation);
    _socketClient.off('shared_ride:passenger_joined', _onPassengerJoined);
    _socketClient.off('shared_ride:passenger_left', _onPassengerLeft);
    _socketClient.off('shared_ride:passenger_removed', _onPassengerRemoved);
    _socketClient.off('shared_ride:removed', _onRiderRemoved);
    _socketClient.off('shared_ride:room_ready', _onRoomReady);
    _socketClient.off('shared_ride:trip_started', _onTripStarted);
    _socketClient.off('shared_ride:passenger_on_board', _onPassengerOnBoard);
    _socketClient.off('shared_ride:passenger_dropped', _onPassengerDropped);
    _socketClient.off('shared_ride:completed', _onTripCompleted);
    _socketClient.off('shared_ride:cancelled', _onTripCancelled);
    _socketClient.off('shared_ride:driver_online', _onDriverOnline);
    _socketClient.off('shared_ride:driver_offline', _onDriverOffline);
    _socketClient.off('shared_ride:passenger_online', _onPassengerOnline);
    _socketClient.off('shared_ride:passenger_offline', _onPassengerOffline);

    if (!_driverLocationController.isClosed) {
      await _driverLocationController.close();
    }
    if (!_passengerJoinedController.isClosed) {
      await _passengerJoinedController.close();
    }
    if (!_passengerLeftController.isClosed) {
      await _passengerLeftController.close();
    }
    if (!_passengerRemovedController.isClosed) {
      await _passengerRemovedController.close();
    }
    if (!_riderRemovedController.isClosed) {
      await _riderRemovedController.close();
    }
    if (!_roomReadyController.isClosed) await _roomReadyController.close();
    if (!_tripStartedController.isClosed) await _tripStartedController.close();
    if (!_passengerOnBoardController.isClosed) {
      await _passengerOnBoardController.close();
    }
    if (!_passengerDroppedController.isClosed) {
      await _passengerDroppedController.close();
    }
    if (!_tripCompletedController.isClosed) {
      await _tripCompletedController.close();
    }
    if (!_tripCancelledController.isClosed) {
      await _tripCancelledController.close();
    }
    if (!_presenceController.isClosed) await _presenceController.close();
  }
}
