import 'package:geolocator/geolocator.dart';
import 'location_status.dart';

abstract class LocationService {
  Future<LocationStatus> checkStatus();
  Future<LocationStatus> requestPermissionIfNeeded();
  Future<Position> getCurrentPosition();
  Future<bool> openLocationSettings();
  Future<bool> openAppSettings();
}

class GeolocatorLocationService implements LocationService {
  @override
  Future<LocationStatus> checkStatus() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    final permission = await Geolocator.checkPermission();
    return LocationStatus(
      serviceEnabled: serviceEnabled,
      permission: _mapPermission(permission),
    );
  }

  @override
  Future<LocationStatus> requestPermissionIfNeeded() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return LocationStatus(
      serviceEnabled: serviceEnabled,
      permission: _mapPermission(permission),
    );
  }

  @override
  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  @override
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  LocationPermissionState _mapPermission(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return LocationPermissionState.granted;
      case LocationPermission.deniedForever:
        return LocationPermissionState.deniedForever;
      case LocationPermission.denied:
      case LocationPermission.unableToDetermine:
        return LocationPermissionState.denied;
    }
  }
}
