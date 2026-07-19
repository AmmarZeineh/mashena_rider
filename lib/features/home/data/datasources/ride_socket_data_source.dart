import 'dart:async';
import 'dart:developer' as developer;

import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/network/socket_client.dart';
import 'package:mashena_rider/features/home/data/models/trip_completed_payload.dart';
import 'package:mashena_rider/features/home/data/models/trip_cancelled_payload.dart';

/// Abstract class defining contracts for the real-time ride socket data source.
abstract interface class RideSocketDataSource {
  /// Stream that fires when a driver is matched to the current ride.
  Stream<int> get rideMatchedStream;

  /// Stream of driver location coordinates in real-time.
  Stream<MapLatLng> get driverLocationStream;

  /// Stream that fires when the driver has arrived.
  Stream<int> get driverArrivedStream;

  /// Stream that fires when the trip has started.
  Stream<int> get driverStartedStream;

  /// Stream that fires when the trip is completed.
  Stream<TripCompletedPayload> get tripCompletedStream;

  /// Stream that fires when the trip is cancelled.
  Stream<TripCancelledPayload> get tripCancelledStream;

  /// Connects the underlying socket to the server.
  Future<void> connectSocket();

  /// Starts listening to updates for a specific ride request.
  void listenToRide(int rideRequestId);

  /// Stops listening to updates for a specific ride request.
  void stopListeningToRide(int rideRequestId);
}

/// Concrete implementation of [RideSocketDataSource].
class RideSocketDataSourceImpl implements RideSocketDataSource {
  final SocketClient _socketClient;

  final StreamController<int> _rideMatchedController =
      StreamController<int>.broadcast();
  final StreamController<MapLatLng> _driverLocationController =
      StreamController<MapLatLng>.broadcast();
  final StreamController<int> _driverArrivedController =
      StreamController<int>.broadcast();
  final StreamController<int> _driverStartedController =
      StreamController<int>.broadcast();
  final StreamController<TripCompletedPayload> _tripCompletedController =
      StreamController<TripCompletedPayload>.broadcast();
  final StreamController<TripCancelledPayload> _tripCancelledController =
      StreamController<TripCancelledPayload>.broadcast();

  RideSocketDataSourceImpl(this._socketClient) {
    _initSocketListeners();
  }

  void _initSocketListeners() {
    _socketClient.on('ride:matched', (data) {
      developer.log(
        'Received ride:matched event: $data',
        name: 'features.home.socket',
      );
      try {
        if (data is Map) {
          final rideRequestId = data['rideRequestId'];
          if (rideRequestId != null) {
            _rideMatchedController.add(int.parse(rideRequestId.toString()));
          }
        }
      } catch (e, stackTrace) {
        developer.log(
          'Error parsing ride:matched payload',
          name: 'features.home.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    });

    _socketClient.on('driver:location', (data) {
      developer.log(
        'Received driver:location event: $data',
        name: 'features.home.socket',
      );
      try {
        if (data is Map) {
          final lat = data['lat'];
          final lng = data['lng'];
          if (lat != null && lng != null) {
            _driverLocationController.add(
              MapLatLng(
                latitude: double.parse(lat.toString()),
                longitude: double.parse(lng.toString()),
              ),
            );
          }
        }
      } catch (e, stackTrace) {
        developer.log(
          'Error parsing driver:location payload',
          name: 'features.home.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    });

    _socketClient.on('trip:driver-arrived', (data) {
      developer.log(
        'Received trip:driver-arrived event: $data',
        name: 'features.home.socket',
      );
      try {
        if (data is Map) {
          final tripId = data['tripId'];
          if (tripId != null) {
            _driverArrivedController.add(int.parse(tripId.toString()));
          }
        }
      } catch (e, stackTrace) {
        developer.log(
          'Error parsing trip:driver-arrived payload',
          name: 'features.home.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    });

    _socketClient.on('trip:driver-started', (data) {
      developer.log(
        'Received trip:driver-started event: $data',
        name: 'features.home.socket',
      );
      try {
        if (data is Map) {
          final tripId = data['tripId'];
          if (tripId != null) {
            _driverStartedController.add(int.parse(tripId.toString()));
          }
        }
      } catch (e, stackTrace) {
        developer.log(
          'Error parsing trip:driver-started payload',
          name: 'features.home.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    });

    _socketClient.on('trip:completed', (data) {
      developer.log(
        'Received trip:completed event: $data',
        name: 'features.home.socket',
      );
      try {
        if (data is Map) {
          final payload = TripCompletedPayload.fromJson(Map<String, dynamic>.from(data));
          _tripCompletedController.add(payload);
        }
      } catch (e, stackTrace) {
        developer.log(
          'Error parsing trip:completed payload',
          name: 'features.home.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    });

    _socketClient.on('trip:cancelled', (data) {
      developer.log(
        'Received trip:cancelled event: $data',
        name: 'features.home.socket',
      );
      try {
        if (data is Map) {
          final payload = TripCancelledPayload.fromJson(Map<String, dynamic>.from(data));
          _tripCancelledController.add(payload);
        }
      } catch (e, stackTrace) {
        developer.log(
          'Error parsing trip:cancelled payload',
          name: 'features.home.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    });
  }

  @override
  Stream<int> get rideMatchedStream => _rideMatchedController.stream;

  @override
  Stream<MapLatLng> get driverLocationStream => _driverLocationController.stream;

  @override
  Stream<int> get driverArrivedStream => _driverArrivedController.stream;

  @override
  Stream<int> get driverStartedStream => _driverStartedController.stream;

  @override
  Stream<TripCompletedPayload> get tripCompletedStream => _tripCompletedController.stream;

  @override
  Stream<TripCancelledPayload> get tripCancelledStream => _tripCancelledController.stream;

  @override
  Future<void> connectSocket() => _socketClient.connect();

  @override
  void listenToRide(int rideRequestId) {
    developer.log(
      'Starting to track ride request $rideRequestId',
      name: 'features.home.socket',
    );
  }

  @override
  void stopListeningToRide(int rideRequestId) {
    developer.log(
      'Stopped tracking ride request $rideRequestId',
      name: 'features.home.socket',
    );
  }
}
