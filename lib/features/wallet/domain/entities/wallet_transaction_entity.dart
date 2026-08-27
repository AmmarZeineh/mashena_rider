import 'package:equatable/equatable.dart';

class WalletTransactionEntity extends Equatable {
  final int id;
  final int walletId;
  final int? transferId;
  final String type;
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final int? tripId;
  final String? description;
  final int userId;
  final String userFullName;
  final String userEmail;
  final DateTime? createdAt;

  const WalletTransactionEntity({
    required this.id,
    required this.walletId,
    this.transferId,
    required this.type,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    this.tripId,
    this.description,
    required this.userId,
    required this.userFullName,
    required this.userEmail,
    this.createdAt,
  });

  bool get isDeposit => type.toUpperCase() == 'DEPOSIT';
  bool get isWithdraw => type.toUpperCase() == 'WITHDRAW';
  bool get isTransfer => type.toUpperCase() == 'TRANSFER';

  String formattedAmount(String currency) {
    final isWhole = amount == amount.roundToDouble();
    final amountText = isWhole
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2);
    final prefix = isDeposit ? '+' : (isWithdraw ? '-' : '');
    return '$prefix$amountText $currency';
  }

  @override
  List<Object?> get props => [
    id,
    walletId,
    transferId,
    type,
    amount,
    balanceBefore,
    balanceAfter,
    tripId,
    description,
    userId,
    userFullName,
    userEmail,
    createdAt,
  ];
}

class WalletTransactionsResponseEntity extends Equatable {
  final int count;
  final List<WalletTransactionEntity> data;

  const WalletTransactionsResponseEntity({
    required this.count,
    required this.data,
  });

  @override
  List<Object?> get props => [count, data];
}
