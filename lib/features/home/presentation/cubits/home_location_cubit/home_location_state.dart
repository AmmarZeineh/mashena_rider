part of 'home_location_cubit.dart';

enum HomeUiState { initial, loading, ready, error }
class HomeState {
  final HomeUiState ui;
  final bool isLocationGranted;
  final bool isLocationServiceEnabled;
  final Position? position;

  const HomeState({
    required this.ui,
    required this.isLocationGranted,
    required this.isLocationServiceEnabled,
    this.position,
  });

  const HomeState.initial()
      : ui = HomeUiState.initial,
        isLocationGranted = false,
        isLocationServiceEnabled = true,
        position = null;

  HomeState copyWith({
    HomeUiState? ui,
    bool? isLocationGranted,
    bool? isLocationServiceEnabled,
    Position? position,
  }) {
    return HomeState(
      ui: ui ?? this.ui,
      isLocationGranted:
          isLocationGranted ?? this.isLocationGranted,
      isLocationServiceEnabled:
          isLocationServiceEnabled ??
              this.isLocationServiceEnabled,
      position: position ?? this.position,
    );
  }
}
