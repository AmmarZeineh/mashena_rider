import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/core/services/device_id_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('DeviceIdService Tests', () {
    test('generates and persists valid deviceId', () async {
      final id1 = await DeviceIdService.getOrCreateDeviceId();
      expect(id1, isNotEmpty);
      expect(id1.split('-').length, equals(5));

      final id2 = await DeviceIdService.getOrCreateDeviceId();
      expect(id2, equals(id1));
    });
  });
}
