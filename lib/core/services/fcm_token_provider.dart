import 'package:mashena_rider/core/services/notification_service.dart';

abstract interface class FcmTokenProvider {
  Future<String?> getFcmToken();
}

class NotificationServiceFcmProvider implements FcmTokenProvider {
  const NotificationServiceFcmProvider();

  @override
  Future<String?> getFcmToken() => NotificationService.getFcmToken();
}
