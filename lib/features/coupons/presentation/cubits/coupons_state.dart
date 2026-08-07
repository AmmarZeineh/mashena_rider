import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/coupons/domain/entities/coupon_history_item_entity.dart';
import 'package:mashena_rider/features/coupons/domain/entities/user_coupon_entity.dart';

enum CouponsStatus { initial, loading, loaded, error }
enum ActivationStatus { initial, loading, success, error }

class CouponsState extends Equatable {
  final CouponsStatus status;
  final ActivationStatus activationStatus;
  final List<UserCouponEntity> activeCoupons;
  final List<CouponHistoryItemEntity> historyItems;
  final Failure? failure;
  final Failure? activationFailure;
  final UserCouponEntity? newlyActivatedCoupon;

  const CouponsState({
    this.status = CouponsStatus.initial,
    this.activationStatus = ActivationStatus.initial,
    this.activeCoupons = const [],
    this.historyItems = const [],
    this.failure,
    this.activationFailure,
    this.newlyActivatedCoupon,
  });

  CouponsState copyWith({
    CouponsStatus? status,
    ActivationStatus? activationStatus,
    List<UserCouponEntity>? activeCoupons,
    List<CouponHistoryItemEntity>? historyItems,
    Failure? failure,
    Failure? activationFailure,
    UserCouponEntity? newlyActivatedCoupon,
  }) {
    return CouponsState(
      status: status ?? this.status,
      activationStatus: activationStatus ?? this.activationStatus,
      activeCoupons: activeCoupons ?? this.activeCoupons,
      historyItems: historyItems ?? this.historyItems,
      failure: failure ?? this.failure,
      activationFailure: activationFailure ?? this.activationFailure,
      newlyActivatedCoupon: newlyActivatedCoupon ?? this.newlyActivatedCoupon,
    );
  }

  @override
  List<Object?> get props => [
        status,
        activationStatus,
        activeCoupons,
        historyItems,
        failure,
        activationFailure,
        newlyActivatedCoupon,
      ];
}
