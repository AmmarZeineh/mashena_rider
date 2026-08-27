import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import '../../../domain/entities/wallet_entity.dart';

enum WalletStatus { initial, loading, loaded, error }

class WalletState extends Equatable {
  final WalletStatus status;
  final WalletEntity? wallet;
  final Failure? failure;
  final bool isRefreshing;

  const WalletState({
    this.status = WalletStatus.initial,
    this.wallet,
    this.failure,
    this.isRefreshing = false,
  });

  bool get isLoading => status == WalletStatus.loading && wallet == null;
  bool get hasData => wallet != null;

  WalletState copyWith({
    WalletStatus? status,
    WalletEntity? wallet,
    Failure? failure,
    bool? isRefreshing,
  }) {
    return WalletState(
      status: status ?? this.status,
      wallet: wallet ?? this.wallet,
      failure: failure ?? this.failure,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [status, wallet, failure, isRefreshing];
}
