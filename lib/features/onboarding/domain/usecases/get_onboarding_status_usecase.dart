import 'package:mashena_rider/core/constants/app_constants.dart';
import 'package:mashena_rider/core/storage/local_storage.dart';

class GetOnboardingStatus {
  GetOnboardingStatus(this._storage);

  final LocalStorage _storage;

  bool call() => _storage.getBool(AppConstants.isOnboardingSeenKey) ?? false;
}
