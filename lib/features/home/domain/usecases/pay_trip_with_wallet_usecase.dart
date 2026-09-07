import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../entities/trip_wallet_payment_entity.dart';
import '../repositories/ride_repository.dart';

class PayTripWithWalletUsecase {
  final RideRepository _repository;

  const PayTripWithWalletUsecase(this._repository);

  Future<Either<Failure, TripWalletPaymentEntity>> call(int rideRequestId) {
    return _repository.payTripWithWallet(rideRequestId);
  }
}
