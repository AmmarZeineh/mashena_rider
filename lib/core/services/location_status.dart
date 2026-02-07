enum LocationPermissionState { granted, denied, deniedForever }

class LocationStatus {
  final bool serviceEnabled;
  final LocationPermissionState permission;

  const LocationStatus({
    required this.serviceEnabled,
    required this.permission,
  });

  bool get isReady =>
      serviceEnabled && permission == LocationPermissionState.granted;
}
