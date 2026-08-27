import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../entities/wallet_transaction_entity.dart';
import '../repositories/wallet_repository.dart';

class GetMyWalletTransactionsUsecase {
  final WalletRepository _repository;

  const GetMyWalletTransactionsUsecase(this._repository);

  Future<Either<Failure, WalletTransactionsResponseEntity>> call({
    int skip = 0,
    int limit = 10,
  }) {
    return _repository.getMyTransactions(skip: skip, limit: limit);
  }
}
