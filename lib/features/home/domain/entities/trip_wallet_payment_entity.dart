import 'package:equatable/equatable.dart';

class TripWalletPaymentEntity extends Equatable {
  final int tripId;
  final num amount;
  final num riderBalanceAfter;
  final int driverUserId;
  final int? transferId;
  final DateTime? paidAt;

  const TripWalletPaymentEntity({
    required this.tripId,
    required this.amount,
    required this.riderBalanceAfter,
    required this.driverUserId,
    this.transferId,
    this.paidAt,
  });

  @override
  List<Object?> get props => [
    tripId,
    amount,
    riderBalanceAfter,
    driverUserId,
    transferId,
    paidAt,
  ];
}
