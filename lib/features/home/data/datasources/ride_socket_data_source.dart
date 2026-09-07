import 'dart:async';
import 'package:mashena_rider/core/services/logger_service.dart';

import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/network/socket_client.dart';
import 'package:mashena_rider/features/home/data/models/driver_arrived_payload.dart';
import 'package:mashena_rider/features/home/data/models/trip_completed_payload.dart';
import 'package:mashena_rider/features/home/data/models/trip_cancelled_payload.dart';

/// Abstract class defining contracts for the real-time ride socket data source.
abstract interface class RideSocketDataSource {
  /// Stream that fires when a driver is matched to the current ride.
  Stream<int> get rideMatchedStream;

  /// Stream of driver location coordinates in real-time.
  Stream<MapLatLng> get driverLocationStream;

  /// Stream that fires when the driver has arrived.
  Stream<DriverArrivedPayload> get driverArrivedStream;

  /// Stream that fires when the trip has started.
  Stream<int> get driverStartedStream;

  /// Stream that fires when the trip is completed.
  Stream<TripCompletedPayload> get tripCompletedStream;

  /// Stream that fires when the trip is cancelled.
  Stream<TripCancelledPayload> get tripCancelledStream;

  /// Stream that fires when the ride request expires without finding a driver.
  Stream<int> get rideExpiredStream;

  /// Stream of the socket connection state updates.
  Stream<bool> get connectionStatusStream;

  /// Connects the underlying socket to the server.
  Future<void> connectSocket();

  /// Starts listening to updates for a specific ride request.
  void listenToRide(int rideRequestId);

  /// Stops listening to updates for a specific ride request.
  void stopListeningToRide(int rideRequestId);

  Future<void> dispose();
}

/// Concrete implementation of [RideSocketDataSource].
class RideSocketDataSourceImpl implements RideSocketDataSource {
  final SocketClient _socketClient;

  final StreamController<int> _rideMatchedController =
      StreamController<int>.broadcast();
  final StreamController<MapLatLng> _driverLocationController =
      StreamController<MapLatLng>.broadcast();
  final StreamController<DriverArrivedPayload> _driverArrivedController =
      StreamController<DriverArrivedPayload>.broadcast();
  final StreamController<int> _driverStartedController =
      StreamController<int>.broadcast();
  final StreamController<TripCompletedPayload> _tripCompletedController =
      StreamController<TripCompletedPayload>.broadcast();
  final StreamController<TripCancelledPayload> _tripCancelledController =
      StreamController<TripCancelledPayload>.broadcast();
  final StreamController<int> _rideExpiredController =
      StreamController<int>.broadcast();

  // Callback references for clean unregistration
  late final void Function(dynamic) _onRideMatched;
  late final void Function(dynamic) _onDriverLocation;
  late final void Function(dynamic) _onDriverArrived;
  late final void Function(dynamic) _onDriverStarted;
  late final void Function(dynamic) _onTripCompleted;
  late final void Function(dynamic) _onTripCancelled;
  late final void Function(dynamic) _onRideExpired;

  RideSocketDataSourceImpl(this._socketClient) {
    _initSocketListeners();
  }

  void _initSocketListeners() {
    _onRideMatched = (data) {
      LoggerService.debug(
        'Received ride:matched event: $data',
        name: 'features.home.socket',
      );
      try {
        if (data is Map && !_rideMatchedController.isClosed) {
          final rideRequestId = data['rideRequestId'];
          if (rideRequestId != null) {
            _rideMatchedController.add(int.parse(rideRequestId.toString()));
          }
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing ride:matched payload',
          name: 'features.home.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('ride:matched', _onRideMatched);

    _onDriverLocation = (data) {
      LoggerService.debug(
        'Received driver:location event: $data',
        name: 'features.home.socket',
      );
      try {
        if (data is Map && !_driverLocationController.isClosed) {
          final lat = data['lat'];
          final lng = data['lng'];
          LoggerService.debug(
            'Parsed lat: $lat, lng: $lng',
            name: 'features.home.socket',
          );

          if (lat != null && lng != null) {
            final position = MapLatLng(
              latitude: double.parse(lat.toString()),
              longitude: double.parse(lng.toString()),
            );
            LoggerService.debug(
              'Adding to driverLocationStream: $position',
              name: 'features.home.socket',
            );
            _driverLocationController.add(position);
          } else {
            LoggerService.debug(
              'lat or lng is null in driver:location payload',
              name: 'features.home.socket',
            );
          }
        } else {
          LoggerService.debug(
            'driver:location payload is not a Map or controller is closed: ${data.runtimeType}',
            name: 'features.home.socket',
          );
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing driver:location payload',
          name: 'features.home.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('driver:location', _onDriverLocation);

    _onDriverArrived = (data) {
      LoggerService.debug(
        'Received trip:driver-arrived event: $data',
        name: 'features.home.socket',
      );
      try {
        if (data is Map && !_driverArrivedController.isClosed) {
          final payload = DriverArrivedPayload.fromJson(
            Map<String, dynamic>.from(data),
          );
          _driverArrivedController.add(payload);
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing trip:driver-arrived payload',
          name: 'features.home.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('trip:driver-arrived', _onDriverArrived);

    _onDriverStarted = (data) {
      LoggerService.debug(
        'Received trip:driver-started event: $data',
        name: 'features.home.socket',
      );
      try {
        if (data is Map && !_driverStartedController.isClosed) {
          final tripId = data['tripId'];
          if (tripId != null) {
            _driverStartedController.add(int.parse(tripId.toString()));
          }
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing trip:driver-started payload',
          name: 'features.home.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('trip:driver-started', _onDriverStarted);

    _onTripCompleted = (data) {
      LoggerService.debug(
        'Received trip:completed event: $data',
        name: 'features.home.socket',
      );
      try {
        if (data is Map && !_tripCompletedController.isClosed) {
          final payload = TripCompletedPayload.fromJson(
            Map<String, dynamic>.from(data),
          );
          _tripCompletedController.add(payload);
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing trip:completed payload',
          name: 'features.home.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('trip:completed', _onTripCompleted);

    _onTripCancelled = (data) {
      LoggerService.debug(
        'Received trip:cancelled event: $data',
        name: 'features.home.socket',
      );
      try {
        if (data is Map && !_tripCancelledController.isClosed) {
          final payload = TripCancelledPayload.fromJson(
            Map<String, dynamic>.from(data),
          );
          _tripCancelledController.add(payload);
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing trip:cancelled payload',
          name: 'features.home.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('trip:cancelled', _onTripCancelled);

    _onRideExpired = (data) {
      LoggerService.debug(
        'Received ride:expired event: $data',
        name: 'features.home.socket',
      );
      try {
        if (data is Map && !_rideExpiredController.isClosed) {
          final rideRequestId = data['rideRequestId'];
          if (rideRequestId != null) {
            _rideExpiredController.add(int.parse(rideRequestId.toString()));
          }
        }
      } catch (e, stackTrace) {
        LoggerService.debug(
          'Error parsing ride:expired payload',
          name: 'features.home.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('ride:expired', _onRideExpired);
  }

  @override
  Stream<int> get rideMatchedStream => _rideMatchedController.stream;

  @override
  Stream<MapLatLng> get driverLocationStream =>
      _driverLocationController.stream;

  @override
  Stream<DriverArrivedPayload> get driverArrivedStream =>
      _driverArrivedController.stream;

  @override
  Stream<int> get driverStartedStream => _driverStartedController.stream;

  @override
  Stream<TripCompletedPayload> get tripCompletedStream =>
      _tripCompletedController.stream;

  @override
  Stream<TripCancelledPayload> get tripCancelledStream =>
      _tripCancelledController.stream;

  @override
  Stream<int> get rideExpiredStream => _rideExpiredController.stream;

  @override
  Stream<bool> get connectionStatusStream =>
      _socketClient.connectionStatusStream;

  @override
  Future<void> connectSocket() => _socketClient.connect();

  /// NOTE: This is intentionally a no-op beyond logging. The app currently
  /// supports only one active ride at a time, so all socket streams are
  /// global and unscoped by [rideRequestId]. If multi-ride support is ever
  /// added, this method must be extended to filter incoming events by ID.
  @override
  void listenToRide(int rideRequestId) {
    LoggerService.debug(
      'Tracking ride request $rideRequestId (global stream, no per-ride filtering)',
      name: 'features.home.socket',
    );
  }

  /// NOTE: This is intentionally a no-op beyond logging. The app currently
  /// supports only one active ride at a time, so all socket streams are
  /// global and unscoped by [rideRequestId]. If multi-ride support is ever
  /// added, this method must be extended to filter incoming events by ID.
  @override
  void stopListeningToRide(int rideRequestId) {
    LoggerService.debug(
      'Stopped tracking ride request $rideRequestId (global stream, no per-ride filtering)',
      name: 'features.home.socket',
    );
  }

  @override
  Future<void> dispose() async {
    // Cleanly unregister callbacks from socket client
    _socketClient.off('ride:matched', _onRideMatched);
    _socketClient.off('driver:location', _onDriverLocation);
    _socketClient.off('trip:driver-arrived', _onDriverArrived);
    _socketClient.off('trip:driver-started', _onDriverStarted);
    _socketClient.off('trip:completed', _onTripCompleted);
    _socketClient.off('trip:cancelled', _onTripCancelled);
    _socketClient.off('ride:expired', _onRideExpired);

    if (!_rideMatchedController.isClosed) await _rideMatchedController.close();
    if (!_driverLocationController.isClosed) {
      await _driverLocationController.close();
    }
    if (!_driverArrivedController.isClosed) {
      await _driverArrivedController.close();
    }
    if (!_driverStartedController.isClosed) {
      await _driverStartedController.close();
    }
    if (!_tripCompletedController.isClosed) {
      await _tripCompletedController.close();
    }
    if (!_tripCancelledController.isClosed) {
      await _tripCancelledController.close();
    }
    if (!_rideExpiredController.isClosed) {
      await _rideExpiredController.close();
    }
  }
}
