import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/constants/app_pagination.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:mashena_rider/features/wallet/domain/usecases/get_my_wallet_transactions_usecase.dart';
import 'package:mashena_rider/features/wallet/presentation/cubits/wallet_transactions_cubit/wallet_transactions_cubit.dart';
import 'package:mashena_rider/features/wallet/presentation/cubits/wallet_transactions_cubit/wallet_transactions_state.dart';

class MockGetMyWalletTransactionsUsecase extends Mock
    implements GetMyWalletTransactionsUsecase {}

void main() {
  late MockGetMyWalletTransactionsUsecase mockUsecase;
  late WalletTransactionsCubit cubit;

  setUp(() {
    mockUsecase = MockGetMyWalletTransactionsUsecase();
    cubit = WalletTransactionsCubit(mockUsecase);
  });

  tearDown(() {
    cubit.close();
  });

  const testTx = WalletTransactionEntity(
    id: 161,
    walletId: 2,
    type: 'DEPOSIT',
    amount: 600.0,
    balanceBefore: 0.0,
    balanceAfter: 600.0,
    userId: 2,
    userFullName: 'Ammar Zeineh',
    userEmail: 't00233977@gmail.com',
  );

  const testResponse = WalletTransactionsResponseEntity(
    count: 1,
    data: [testTx],
  );

  test('initial state should be WalletTransactionsStatus.initial', () {
    expect(cubit.state.status, equals(WalletTransactionsStatus.initial));
    expect(cubit.state.items, isEmpty);
    expect(cubit.state.hasMore, isFalse);
  });

  test(
    'fetchInitialTransactions emits [loading, success] on success',
    () async {
      when(
        () => mockUsecase(skip: 0, limit: AppPagination.defaultPageSize),
      ).thenAnswer((_) async => const Right(testResponse));

      expectLater(
        cubit.stream,
        emitsInOrder([
          const WalletTransactionsState(
            status: WalletTransactionsStatus.loading,
          ),
          const WalletTransactionsState(
            status: WalletTransactionsStatus.success,
            items: [testTx],
            totalCount: 1,
            page: 1,
            hasMore: false,
          ),
        ]),
      );

      await cubit.fetchInitialTransactions();
      verify(
        () => mockUsecase(skip: 0, limit: AppPagination.defaultPageSize),
      ).called(1);
    },
  );

  test('fetchInitialTransactions emits [loading, failure] on error', () async {
    const failure = Failure(FailureCode.server);
    when(
      () => mockUsecase(skip: 0, limit: AppPagination.defaultPageSize),
    ).thenAnswer((_) async => const Left(failure));

    expectLater(
      cubit.stream,
      emitsInOrder([
        const WalletTransactionsState(status: WalletTransactionsStatus.loading),
        const WalletTransactionsState(
          status: WalletTransactionsStatus.failure,
          failure: failure,
        ),
      ]),
    );

    await cubit.fetchInitialTransactions();
  });
}
