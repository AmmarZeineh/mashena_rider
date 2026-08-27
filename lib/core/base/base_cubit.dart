import 'package:flutter_bloc/flutter_bloc.dart';

/// A base [Cubit] class that safely handles state emissions.
///
/// Overrides [emit] to ensure that states are only emitted when the cubit
/// is still open (`!isClosed`), preventing [StateError] exceptions from
/// asynchronous operations completing after the cubit lifecycle has ended.
abstract class BaseCubit<State> extends Cubit<State> {
  BaseCubit(super.initialState);

  @override
  void emit(State state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
