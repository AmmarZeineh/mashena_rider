import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/wallet/domain/entities/wallet_entity.dart';
import 'package:mashena_rider/features/wallet/domain/entities/wallet_transaction_entity.dart';

abstract interface class WalletRepository {
  Future<Either<Failure, WalletEntity>> getMyWallet();

  Future<Either<Failure, WalletTransactionsResponseEntity>> getMyTransactions({
    int skip = 0,
    int limit = 10,
  });
}
