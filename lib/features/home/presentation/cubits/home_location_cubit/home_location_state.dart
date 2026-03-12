part of 'home_location_cubit.dart';

enum HomeUiState { initial, loading, ready, error }
class HomeState {
  final HomeUiState ui;
  final bool isLocationGranted;
  final bool isLocationServiceEnabled;
  final bool isDeniedForever;
  final Position? position;

  const HomeState({
    required this.ui,
    required this.isLocationGranted,
    required this.isLocationServiceEnabled,
    this.isDeniedForever = false,
    this.position,
  });

  const HomeState.initial()
      : ui = HomeUiState.initial,
        isLocationGranted = false,
        isLocationServiceEnabled = true,
        isDeniedForever = false,
        position = null;

  HomeState copyWith({
    HomeUiState? ui,
    bool? isLocationGranted,
    bool? isLocationServiceEnabled,
    bool? isDeniedForever,
    Position? position,
  }) {
    return HomeState(
      ui: ui ?? this.ui,
      isLocationGranted:
          isLocationGranted ?? this.isLocationGranted,
      isLocationServiceEnabled:
          isLocationServiceEnabled ??
              this.isLocationServiceEnabled,
      isDeniedForever: isDeniedForever ?? this.isDeniedForever,
      position: position ?? this.position,
    );
  }
}

