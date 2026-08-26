import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import 'package:mashena_rider/core/network/api_exception.dart';
import 'package:mashena_rider/core/network/api_failure_mapper.dart';
import 'package:mashena_rider/features/notifications/data/models/notifications_data_model.dart';
import 'package:mashena_rider/features/notifications/domain/entities/notifications_data.dart';
import 'package:mashena_rider/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final ApiClient _api;

  NotificationsRepositoryImpl(this._api);

  @override
  Future<Either<Failure, NotificationsData>> getNotifications({
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      final response = await _api.get(
        BackendEndpoints.notifications,
        query: {'skip': skip, 'limit': limit},
      );
      final map = response as Map<String, dynamic>;
      final model = NotificationsDataModel.fromJson(map);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> markAsRead(int id) async {
    try {
      final response = await _api.patch(
        BackendEndpoints.markNotificationRead(id),
      );
      final map = response as Map<String, dynamic>?;
      final count = (map?['count'] as num?)?.toInt() ?? 1;
      return Right(count);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> markAllAsRead() async {
    try {
      final response = await _api.patch(
        BackendEndpoints.markAllNotificationsRead,
      );
      final map = response as Map<String, dynamic>?;
      final count = (map?['count'] as num?)?.toInt() ?? 0;
      return Right(count);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerToken({
    required String token,
    String? platform,
    String? deviceId,
  }) async {
    try {
      await _api.post(
        BackendEndpoints.notificationToken,
        body: {'token': token, 'platform': ?platform, 'deviceId': ?deviceId},
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unregisterToken(String token) async {
    try {
      await _api.delete(
        BackendEndpoints.notificationToken,
        body: {'token': token},
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(FailureCode.unknown, rawMessage: e.toString()));
    }
  }
}
