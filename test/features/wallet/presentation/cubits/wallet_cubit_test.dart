import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/wallet/domain/entities/wallet_entity.dart';
import 'package:mashena_rider/features/wallet/domain/usecases/get_my_wallet_usecase.dart';
import 'package:mashena_rider/features/wallet/presentation/cubits/wallet_cubit/wallet_cubit.dart';
import 'package:mashena_rider/features/wallet/presentation/cubits/wallet_cubit/wallet_state.dart';

class MockGetMyWalletUsecase extends Mock implements GetMyWalletUsecase {}

void main() {
  late MockGetMyWalletUsecase mockUsecase;
  late WalletCubit cubit;

  setUp(() {
    mockUsecase = MockGetMyWalletUsecase();
    cubit = WalletCubit(mockUsecase);
  });

  tearDown(() {
    cubit.close();
  });

  const testWallet = WalletEntity(
    id: 2,
    userId: 2,
    balance: 600.0,
    currency: 'SYR',
    status: 'ACTIVE',
  );

  test('initial state should be WalletStatus.initial', () {
    expect(cubit.state.status, equals(WalletStatus.initial));
    expect(cubit.state.wallet, isNull);
    expect(cubit.state.failure, isNull);
  });

  test('fetchWallet emits [loading, loaded] when usecase succeeds', () async {
    when(() => mockUsecase()).thenAnswer((_) async => const Right(testWallet));

    expectLater(
      cubit.stream,
      emitsInOrder([
        const WalletState(status: WalletStatus.loading),
        const WalletState(
          status: WalletStatus.loaded,
          wallet: testWallet,
          isRefreshing: false,
        ),
      ]),
    );

    await cubit.fetchWallet();
    verify(() => mockUsecase()).called(1);
  });

  test('fetchWallet emits [loading, error] when usecase fails', () async {
    const failure = Failure(FailureCode.networkConnection);
    when(() => mockUsecase()).thenAnswer((_) async => const Left(failure));

    expectLater(
      cubit.stream,
      emitsInOrder([
        const WalletState(status: WalletStatus.loading),
        const WalletState(
          status: WalletStatus.error,
          failure: failure,
          isRefreshing: false,
        ),
      ]),
    );

    await cubit.fetchWallet();
    verify(() => mockUsecase()).called(1);
  });

  test(
    'refreshWallet updates wallet seamlessly with isRefreshing true',
    () async {
      when(
        () => mockUsecase(),
      ).thenAnswer((_) async => const Right(testWallet));

      expectLater(
        cubit.stream,
        emitsInOrder([
          const WalletState(isRefreshing: true),
          const WalletState(
            status: WalletStatus.loaded,
            wallet: testWallet,
            isRefreshing: false,
          ),
        ]),
      );

      await cubit.refreshWallet();
      verify(() => mockUsecase()).called(1);
    },
  );
}
