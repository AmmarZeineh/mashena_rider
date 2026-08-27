import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/features/wallet/data/models/wallet_model.dart';

void main() {
  group('WalletModel', () {
    final sampleJson = {
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

    test('should parse correctly from json', () {
      final model = WalletModel.fromJson(sampleJson);

      expect(model.id, equals(2));
      expect(model.userId, equals(2));
      expect(model.balance, equals(600.0));
      expect(model.currency, equals('SYR'));
      expect(model.status, equals('ACTIVE'));
      expect(model.user, isNotNull);
      expect(model.user!.fullName, equals('Ammar Zeineh'));
      expect(model.user!.email, equals('t00233977@gmail.com'));
      expect(model.user!.phoneNumber, equals('0985398398'));
      expect(model.user!.driverProfileId, isNull);
      expect(model.createdAt, isNotNull);
      expect(model.updatedAt, isNotNull);
    });

    test('toEntity should convert to a valid WalletEntity', () {
      final model = WalletModel.fromJson(sampleJson);
      final entity = model.toEntity();

      expect(entity.id, equals(2));
      expect(entity.userId, equals(2));
      expect(entity.balance, equals(600.0));
      expect(entity.currency, equals('SYR'));
      expect(entity.status, equals('ACTIVE'));
      expect(entity.isActive, isTrue);
      expect(entity.formattedBalance, equals('600 SYR'));
      expect(entity.user?.fullName, equals('Ammar Zeineh'));
    });

    test('should handle decimal balance and null user gracefully', () {
      final json = {
        "id": 5,
        "userId": 10,
        "balance": 1500.75,
        "currency": "USD",
        "status": "INACTIVE",
        "user": null,
      };

      final model = WalletModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.balance, equals(1500.75));
      expect(entity.isActive, isFalse);
      expect(entity.formattedBalance, equals('1500.75 USD'));
      expect(entity.user, isNull);
    });
  });
}
