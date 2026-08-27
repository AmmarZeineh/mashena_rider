import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import 'package:mashena_rider/core/network/api_exception.dart';
import 'package:mashena_rider/core/network/api_failure_mapper.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/entities/wallet_transaction_entity.dart';
import '../../domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final ApiClient api;

  WalletRepositoryImpl(this.api);

  @override
  Future<Either<Failure, WalletEntity>> getMyWallet() async {
    try {
      final response = await api.get(BackendEndpoints.myWallet);
      final model = WalletModel.fromJson(response as Map<String, dynamic>);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WalletTransactionsResponseEntity>> getMyTransactions({
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      final response = await api.get(
        BackendEndpoints.walletTransactions,
        query: {'skip': skip, 'limit': limit},
      );
      final model = WalletTransactionsResponseModel.fromJson(
        response as Map<String, dynamic>,
      );
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }
}
