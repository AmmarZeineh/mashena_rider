import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import 'package:mashena_rider/core/network/api_exception.dart';
import 'package:mashena_rider/core/network/api_failure_mapper.dart';
import 'package:mashena_rider/features/coupons/data/models/coupon_history_item_model.dart';
import 'package:mashena_rider/features/coupons/data/models/user_coupon_model.dart';
import 'package:mashena_rider/features/coupons/domain/entities/coupon_history_item_entity.dart';
import 'package:mashena_rider/features/coupons/domain/entities/user_coupon_entity.dart';
import 'package:mashena_rider/features/coupons/domain/repositories/coupons_repository.dart';

class CouponsRepositoryImpl implements CouponsRepository {
  final ApiClient api;

  CouponsRepositoryImpl(this.api);

  @override
  Future<Either<Failure, UserCouponEntity>> activateCoupon(String code) async {
    try {
      final response = await api.post(
        BackendEndpoints.activateCoupon,
        body: {'code': code},
      );
      final model = UserCouponModel.fromJson(response as Map<String, dynamic>);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserCouponEntity>>> getMyCoupons({
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      final response = await api.get(
        BackendEndpoints.myCoupons,
        query: {'skip': skip, 'limit': limit},
      );
      final map = response as Map<String, dynamic>;
      final list = (map['data'] as List? ?? [])
          .map(
            (item) => UserCouponModel.fromJson(
              item as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();
      return Right(list);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CouponHistoryItemEntity>>> getMyHistory({
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      final response = await api.get(
        BackendEndpoints.myCouponHistory,
        query: {'skip': skip, 'limit': limit},
      );
      final map = response as Map<String, dynamic>;
      final list = (map['data'] as List? ?? [])
          .map(
            (item) => CouponHistoryItemModel.fromJson(
              item as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();
      return Right(list);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }
}
