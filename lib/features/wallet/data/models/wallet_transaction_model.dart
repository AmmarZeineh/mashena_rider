import '../../domain/entities/wallet_transaction_entity.dart';

class WalletTransactionModel {
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

  const WalletTransactionModel({
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

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: _toInt(json['id']) ?? 0,
      walletId: _toInt(json['walletId']) ?? 0,
      transferId: _toInt(json['transferId']),
      type: json['type'] as String? ?? 'DEPOSIT',
      amount: _toDouble(json['amount']),
      balanceBefore: _toDouble(json['balanceBefore']),
      balanceAfter: _toDouble(json['balanceAfter']),
      tripId: _toInt(json['tripId']),
      description: json['description'] as String?,
      userId: _toInt(json['userId']) ?? 0,
      userFullName: json['userFullName'] as String? ?? '',
      userEmail: json['userEmail'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  WalletTransactionEntity toEntity() {
    return WalletTransactionEntity(
      id: id,
      walletId: walletId,
      transferId: transferId,
      type: type,
      amount: amount,
      balanceBefore: balanceBefore,
      balanceAfter: balanceAfter,
      tripId: tripId,
      description: description,
      userId: userId,
      userFullName: userFullName,
      userEmail: userEmail,
      createdAt: createdAt,
    );
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0.0;
  }

  static int? _toInt(dynamic val) {
    if (val == null) return null;
    if (val is int) return val;
    if (val is num) return val.toInt();
    return int.tryParse(val.toString());
  }
}

class WalletTransactionsResponseModel {
  final int count;
  final List<WalletTransactionModel> data;

  const WalletTransactionsResponseModel({
    required this.count,
    required this.data,
  });

  factory WalletTransactionsResponseModel.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List? ?? [])
        .map(
          (item) =>
              WalletTransactionModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
    return WalletTransactionsResponseModel(
      count: WalletTransactionModel._toInt(json['count']) ?? list.length,
      data: list,
    );
  }

  WalletTransactionsResponseEntity toEntity() {
    return WalletTransactionsResponseEntity(
      count: count,
      data: data.map((e) => e.toEntity()).toList(),
    );
  }
}
