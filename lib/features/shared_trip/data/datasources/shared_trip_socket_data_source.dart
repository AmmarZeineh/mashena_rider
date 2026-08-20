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

  SharedTripSocketDataSourceImpl(this._socketClient) {
    _initSocketListeners();
  }

  void _initSocketListeners() {
    _socketClient.on('shared_ride:driver_location', (data) {
      LoggerService.debug(
        'Received shared_ride:driver_location event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
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
    });

    _socketClient.on('shared_ride:passenger_joined', (data) {
      LoggerService.debug(
        'Received shared_ride:passenger_joined event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map) {
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
    });

    _socketClient.on('shared_ride:passenger_left', (data) {
      LoggerService.debug(
        'Received shared_ride:passenger_left event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map) {
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
    });

    _socketClient.on('shared_ride:passenger_removed', (data) {
      LoggerService.debug(
        'Received shared_ride:passenger_removed event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map) {
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
    });

    _socketClient.on('shared_ride:removed', (data) {
      LoggerService.debug(
        'Received shared_ride:removed event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map) {
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
    });

    _socketClient.on('shared_ride:room_ready', (data) {
      LoggerService.debug(
        'Received shared_ride:room_ready event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map) {
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
    });

    _socketClient.on('shared_ride:trip_started', (data) {
      LoggerService.debug(
        'Received shared_ride:trip_started event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map) {
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
    });

    _socketClient.on('shared_ride:passenger_on_board', (data) {
      LoggerService.debug(
        'Received shared_ride:passenger_on_board event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map) {
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
    });

    _socketClient.on('shared_ride:passenger_dropped', (data) {
      LoggerService.debug(
        'Received shared_ride:passenger_dropped event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map) {
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
    });

    _socketClient.on('shared_ride:completed', (data) {
      LoggerService.debug(
        'Received shared_ride:completed event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map) {
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
    });

    _socketClient.on('shared_ride:cancelled', (data) {
      LoggerService.debug(
        'Received shared_ride:cancelled event: $data',
        name: 'features.shared_trip.socket',
      );
      try {
        if (data is Map) {
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
    });

    // Presence listeners
    _socketClient.on('shared_ride:driver_online', (data) {
      _handlePresence(data, isOnline: true, isDriver: true);
    });
    _socketClient.on('shared_ride:driver_offline', (data) {
      _handlePresence(data, isOnline: false, isDriver: true);
    });
    _socketClient.on('shared_ride:passenger_online', (data) {
      _handlePresence(data, isOnline: true, isDriver: false);
    });
    _socketClient.on('shared_ride:passenger_offline', (data) {
      _handlePresence(data, isOnline: false, isDriver: false);
    });
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
      if (data is Map) {
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
    LoggerService.debug(
      'Tracking shared ride room $sharedRideId',
      name: 'features.shared_trip.socket',
    );
  }

  @override
  void stopListeningToRoom(int sharedRideId) {
    LoggerService.debug(
      'Stopped tracking shared ride room $sharedRideId',
      name: 'features.shared_trip.socket',
    );
  }

  @override
  Future<void> dispose() async {
    await _driverLocationController.close();
    await _passengerJoinedController.close();
    await _passengerLeftController.close();
    await _passengerRemovedController.close();
    await _riderRemovedController.close();
    await _roomReadyController.close();
    await _tripStartedController.close();
    await _passengerOnBoardController.close();
    await _passengerDroppedController.close();
    await _tripCompletedController.close();
    await _tripCancelledController.close();
    await _presenceController.close();
  }
}
