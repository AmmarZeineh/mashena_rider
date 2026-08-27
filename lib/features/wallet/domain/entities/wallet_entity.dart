import 'package:equatable/equatable.dart';

class WalletEntity extends Equatable {
  final int id;
  final int userId;
  final double balance;
  final String currency;
  final String status;
  final WalletUserEntity? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const WalletEntity({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.status,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  bool get isActive => status.trim().toUpperCase() == 'ACTIVE';

  /// Formats the balance with the currency (e.g. "600 SYR" or "600.50 SYR")
  String get formattedBalance {
    final isWhole = balance == balance.roundToDouble();
    final balanceText = isWhole
        ? balance.toInt().toString()
        : balance.toStringAsFixed(2);
    return '$balanceText $currency';
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    balance,
    currency,
    status,
    user,
    createdAt,
    updatedAt,
  ];
}

class WalletUserEntity extends Equatable {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final int? driverProfileId;

  const WalletUserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.driverProfileId,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phoneNumber,
    driverProfileId,
  ];
}
