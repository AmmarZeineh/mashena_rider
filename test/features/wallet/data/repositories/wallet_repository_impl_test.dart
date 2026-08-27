import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import 'package:mashena_rider/core/network/api_exception.dart';
import 'package:mashena_rider/features/wallet/data/repositories/wallet_repository_impl.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late WalletRepositoryImpl repository;

  setUp(() {
    mockApiClient = MockApiClient();
    repository = WalletRepositoryImpl(mockApiClient);
  });

  final sampleResponse = {
    "id": 2,
    "userId": 2,
    "balance": 600,
    "currency": "SYR",
    "status": "ACTIVE",
    "user": {
      "id": 2,
      "fullName": "Ammar Zeineh",
      "email": "t00233977@gmail.com",
      "phoneNumber": "0985398398",
      "driverProfileId": null,
    },
    "createdAt": "2026-08-17T11:02:20.212Z",
    "updatedAt": "2026-08-27T00:11:21.824Z",
  };

  test(
    'getMyWallet returns Right(WalletEntity) on successful API response',
    () async {
      when(
        () => mockApiClient.get(BackendEndpoints.myWallet),
      ).thenAnswer((_) async => sampleResponse);

      final result = await repository.getMyWallet();

      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('Should have returned wallet entity'), (
        wallet,
      ) {
        expect(wallet.id, equals(2));
        expect(wallet.balance, equals(600.0));
        expect(wallet.currency, equals('SYR'));
        expect(wallet.status, equals('ACTIVE'));
      });
      verify(() => mockApiClient.get(BackendEndpoints.myWallet)).called(1);
    },
  );

  test('getMyWallet returns Left(Failure) when ApiException occurs', () async {
    when(() => mockApiClient.get(BackendEndpoints.myWallet)).thenThrow(
      const ApiException(
        ApiErrorCode.badResponse,
        message: 'Not found',
        statusCode: 404,
      ),
    );

    final result = await repository.getMyWallet();

    expect(result.isLeft(), isTrue);
    result.fold((failure) {
      expect(failure.code, equals(FailureCode.notFound));
    }, (_) => fail('Should have returned failure'));
  });

  test('getMyWallet returns Left(Failure) on unexpected exception', () async {
    when(
      () => mockApiClient.get(BackendEndpoints.myWallet),
    ).thenThrow(Exception('Server unreachable'));

    final result = await repository.getMyWallet();

    expect(result.isLeft(), isTrue);
    result.fold((failure) {
      expect(failure.code, equals(FailureCode.unknown));
    }, (_) => fail('Should have returned failure'));
  });

  group('getMyTransactions', () {
    final sampleTxResponse = {
      "count": 1,
      "data": [
        {
          "id": 161,
          "walletId": 2,
          "transferId": null,
          "type": "DEPOSIT",
          "amount": 600,
          "balanceBefore": 0,
          "balanceAfter": 600,
          "tripId": null,
          "description": "",
          "userId": 2,
          "userFullName": "Ammar Zeineh",
          "userEmail": "t00233977@gmail.com",
          "createdAt": "2026-08-27T00:11:21.832Z",
        },
      ],
    };

    test(
      'returns Right(WalletTransactionsResponseEntity) on success',
      () async {
        when(
          () => mockApiClient.get(
            BackendEndpoints.walletTransactions,
            query: {'skip': 0, 'limit': 10},
          ),
        ).thenAnswer((_) async => sampleTxResponse);

        final result = await repository.getMyTransactions(skip: 0, limit: 10);

        expect(result.isRight(), isTrue);
        result.fold((_) => fail('Should succeed'), (response) {
          expect(response.count, equals(1));
          expect(response.data.first.id, equals(161));
          expect(response.data.first.amount, equals(600.0));
        });
      },
    );

    test('returns Left(Failure) on ApiException', () async {
      when(
        () => mockApiClient.get(
          BackendEndpoints.walletTransactions,
          query: {'skip': 0, 'limit': 10},
        ),
      ).thenThrow(
        const ApiException(
          ApiErrorCode.badResponse,
          statusCode: 500,
          message: 'Error',
        ),
      );

      final result = await repository.getMyTransactions(skip: 0, limit: 10);

      expect(result.isLeft(), isTrue);
    });
  });
}
