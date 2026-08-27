import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../entities/wallet_entity.dart';
import '../repositories/wallet_repository.dart';

class GetMyWalletUsecase {
  final WalletRepository _repository;

  const GetMyWalletUsecase(this._repository);

  Future<Either<Failure, WalletEntity>> call() {
    return _repository.getMyWallet();
  }
}
