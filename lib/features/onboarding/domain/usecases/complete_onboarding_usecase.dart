import 'package:mashena_rider/core/constants/app_constants.dart';
import 'package:mashena_rider/core/storage/local_storage.dart';

class CompleteOnboarding {
  CompleteOnboarding(this._storage);

  final LocalStorage _storage;

  Future<void> call() async {
    await _storage.setBool(AppConstants.isOnboardingSeenKey, true);
  }
}
