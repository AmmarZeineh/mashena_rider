import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/features/wallet/data/models/wallet_transaction_model.dart';

void main() {
  group('WalletTransactionsResponseModel', () {
    final sampleJson = {
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

    test('should parse list and count correctly from json', () {
      final responseModel = WalletTransactionsResponseModel.fromJson(
        sampleJson,
      );

      expect(responseModel.count, equals(1));
      expect(responseModel.data.length, equals(1));

      final tx = responseModel.data.first;
      expect(tx.id, equals(161));
      expect(tx.walletId, equals(2));
      expect(tx.transferId, isNull);
      expect(tx.type, equals('DEPOSIT'));
      expect(tx.amount, equals(600.0));
      expect(tx.balanceBefore, equals(0.0));
      expect(tx.balanceAfter, equals(600.0));
      expect(tx.tripId, isNull);
      expect(tx.description, equals(''));
      expect(tx.userId, equals(2));
      expect(tx.userFullName, equals('Ammar Zeineh'));
      expect(tx.userEmail, equals('t00233977@gmail.com'));
      expect(tx.createdAt, isNotNull);
    });

    test('toEntity should map to domain entity correctly', () {
      final responseModel = WalletTransactionsResponseModel.fromJson(
        sampleJson,
      );
      final entity = responseModel.toEntity();

      expect(entity.count, equals(1));
      expect(entity.data.length, equals(1));

      final tx = entity.data.first;
      expect(tx.id, equals(161));
      expect(tx.isDeposit, isTrue);
      expect(tx.isWithdraw, isFalse);
      expect(tx.formattedAmount('SYR'), equals('+600 SYR'));
    });
  });
}
