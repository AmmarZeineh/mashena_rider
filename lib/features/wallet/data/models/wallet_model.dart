import '../../domain/entities/wallet_entity.dart';

class WalletModel {
  final int id;
  final int userId;
  final double balance;
  final String currency;
  final String status;
  final WalletUserModel? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.status,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: _toInt(json['id']) ?? 0,
      userId: _toInt(json['userId']) ?? 0,
      balance: _toDouble(json['balance']),
      currency: json['currency'] as String? ?? 'SYR',
      status: json['status'] as String? ?? 'ACTIVE',
      user: json['user'] != null && json['user'] is Map<String, dynamic>
          ? WalletUserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  WalletEntity toEntity() {
    return WalletEntity(
      id: id,
      userId: userId,
      balance: balance,
      currency: currency,
      status: status,
      user: user?.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
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

class WalletUserModel {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final int? driverProfileId;

  const WalletUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.driverProfileId,
  });

  factory WalletUserModel.fromJson(Map<String, dynamic> json) {
    return WalletUserModel(
      id: WalletModel._toInt(json['id']) ?? 0,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      driverProfileId: WalletModel._toInt(json['driverProfileId']),
    );
  }

  WalletUserEntity toEntity() {
    return WalletUserEntity(
      id: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      driverProfileId: driverProfileId,
    );
  }
}
