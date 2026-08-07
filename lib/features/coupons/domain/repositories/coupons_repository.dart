import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/coupons/domain/entities/coupon_history_item_entity.dart';
import 'package:mashena_rider/features/coupons/domain/entities/user_coupon_entity.dart';

abstract class CouponsRepository {
  Future<Either<Failure, UserCouponEntity>> activateCoupon(String code);
  Future<Either<Failure, List<UserCouponEntity>>> getMyCoupons({
    int skip = 0,
    int limit = 10,
  });
  Future<Either<Failure, List<CouponHistoryItemEntity>>> getMyHistory({
    int skip = 0,
    int limit = 10,
  });
}
