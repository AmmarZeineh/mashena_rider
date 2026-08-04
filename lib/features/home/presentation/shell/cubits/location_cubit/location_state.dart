part of 'location_cubit.dart';

/// Holds GPS permission status and the last known device position.
class LocationState extends Equatable {
  const LocationState({
    this.isGranted = false,
    this.isServiceEnabled = true,
    this.isDeniedForever = false,
    this.position,
  });

  const LocationState.initial()
      : isGranted = false,
        isServiceEnabled = true,
        isDeniedForever = false,
        position = null;

  final bool isGranted;
  final bool isServiceEnabled;
  final bool isDeniedForever;
  final Position? position;

  @override
  List<Object?> get props => [
        isGranted,
        isServiceEnabled,
        isDeniedForever,
        position,
      ];

  @override
  bool get stringify => true;

  LocationState copyWith({
    bool? isGranted,
    bool? isServiceEnabled,
    bool? isDeniedForever,
    Position? position,
  }) {
    return LocationState(
      isGranted: isGranted ?? this.isGranted,
      isServiceEnabled: isServiceEnabled ?? this.isServiceEnabled,
      isDeniedForever: isDeniedForever ?? this.isDeniedForever,
      position: position ?? this.position,
    );
  }
}
