import '../../domain/entities/trip_wallet_payment_entity.dart';

class TripWalletPaymentModel {
  final int tripId;
  final num amount;
  final num riderBalanceAfter;
  final int driverUserId;
  final int? transferId;
  final DateTime? paidAt;

  const TripWalletPaymentModel({
    required this.tripId,
    required this.amount,
    required this.riderBalanceAfter,
    required this.driverUserId,
    this.transferId,
    this.paidAt,
  });

  factory TripWalletPaymentModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final tripIdRaw = data['tripId'] ?? data['trip_id'] ?? 0;
    final amountRaw = data['amount'] ?? 0;
    final balanceRaw =
        data['riderBalanceAfter'] ?? data['rider_balance_after'] ?? 0;
    final driverUserIdRaw = data['driverUserId'] ?? data['driver_user_id'] ?? 0;
    final transferIdRaw = data['transferId'] ?? data['transfer_id'];
    final paidAtRaw = data['paidAt'] ?? data['paid_at'];

    return TripWalletPaymentModel(
      tripId: tripIdRaw is int
          ? tripIdRaw
          : int.tryParse(tripIdRaw.toString()) ?? 0,
      amount: amountRaw is num
          ? amountRaw
          : num.tryParse(amountRaw.toString()) ?? 0,
      riderBalanceAfter: balanceRaw is num
          ? balanceRaw
          : num.tryParse(balanceRaw.toString()) ?? 0,
      driverUserId: driverUserIdRaw is int
          ? driverUserIdRaw
          : int.tryParse(driverUserIdRaw.toString()) ?? 0,
      transferId: transferIdRaw != null
          ? (transferIdRaw is int
                ? transferIdRaw
                : int.tryParse(transferIdRaw.toString()))
          : null,
      paidAt: paidAtRaw != null
          ? DateTime.tryParse(paidAtRaw.toString())
          : null,
    );
  }

  TripWalletPaymentEntity toEntity() {
    return TripWalletPaymentEntity(
      tripId: tripId,
      amount: amount,
      riderBalanceAfter: riderBalanceAfter,
      driverUserId: driverUserId,
      transferId: transferId,
      paidAt: paidAt,
    );
  }
}
