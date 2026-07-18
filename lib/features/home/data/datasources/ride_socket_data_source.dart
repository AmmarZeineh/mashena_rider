import 'dart:async';
import 'dart:developer' as developer;

import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/network/socket_client.dart';

/// Abstract class defining contracts for the real-time ride socket data source.
abstract interface class RideSocketDataSource {
  /// Stream that fires when a driver is matched to the current ride.
  Stream<int> get rideMatchedStream;

  /// Stream of driver location coordinates in real-time.
  Stream<MapLatLng> get driverLocationStream;

  /// Stream that fires when the driver has arrived.
  Stream<int> get driverArrivedStream;

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
  }

  @override
  Stream<int> get rideMatchedStream => _rideMatchedController.stream;

  @override
  Stream<MapLatLng> get driverLocationStream => _driverLocationController.stream;

  @override
  Stream<int> get driverArrivedStream => _driverArrivedController.stream;

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
