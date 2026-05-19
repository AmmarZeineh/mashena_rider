import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/app/app.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    dotenv.loadFromString(
      envString: '''
BASE_URL=https://example.test
API_KEY=test-api-key
ENABLE_NETWORK_LOGS=false
''',
    );
    SharedPreferences.setMockInitialValues({});
    await getIt.reset();
    await configureDependencies();
  });

  testWidgets('renders the app shell', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(designSize: const Size(428, 926), child: const App()),
    );

    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
