import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/core/base/base_cubit.dart';

class _TestSafeCubit extends BaseCubit<int> {
  _TestSafeCubit() : super(0);

  void increment() => emit(state + 1);
}

void main() {
  group('BaseCubit', () {
    test('emits state normally when not closed', () {
      final cubit = _TestSafeCubit();
      expect(cubit.state, 0);

      cubit.increment();
      expect(cubit.state, 1);

      cubit.close();
    });

    test('does not throw StateError and silently ignores emit when closed',
        () async {
      final cubit = _TestSafeCubit();
      await cubit.close();

      expect(cubit.isClosed, isTrue);

      // Calling emit on a standard Cubit throws StateError.
      // BaseCubit must suppress it cleanly.
      expect(() => cubit.increment(), returnsNormally);
      expect(cubit.state, 0);
    });
  });
}
