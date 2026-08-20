import 'package:dartz/dartz.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/notifications/domain/entities/notifications_data.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, NotificationsData>> getNotifications({
    int skip = 0,
    int limit = 10,
  });
}
