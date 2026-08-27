import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/core/storage/local_storage.dart';
import 'package:mashena_rider/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:mashena_rider/features/settings/presentation/cubits/settings_state.dart';

class FakeLocalStorage implements LocalStorage {
  final Map<String, dynamic> _storage = {};

  @override
  bool containsKey(String key) => _storage.containsKey(key);

  @override
  bool? getBool(String key) => _storage[key] as bool?;

  @override
  int? getInt(String key) => _storage[key] as int?;

  @override
  String? getString(String key) => _storage[key] as String?;

  @override
  Future<bool> setBool(String key, bool value) async {
    _storage[key] = value;
    return true;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    _storage[key] = value;
    return true;
  }

  @override
  Future<bool> setString(String key, String value) async {
    _storage[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    _storage.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _storage.clear();
    return true;
  }
}

void main() {
  group('SettingsCubit Tests', () {
    late FakeLocalStorage storage;
    late SettingsCubit cubit;

    setUp(() {
      storage = FakeLocalStorage();
    });

    test('initial state defaults to ThemeMode.system and null locale when storage empty', () {
      cubit = SettingsCubit(storage);
      expect(cubit.state, const SettingsState(themeMode: ThemeMode.system, locale: null));
    });

    test('initial state loads persisted theme and language from storage', () {
      storage.setString(SettingsCubit.themeModeKey, 'dark');
      storage.setString(SettingsCubit.languageCodeKey, 'ar');

      cubit = SettingsCubit(storage);
      expect(cubit.state.themeMode, ThemeMode.dark);
      expect(cubit.state.locale, const Locale('ar'));
    });

    test('setThemeMode updates state and saves to storage', () async {
      cubit = SettingsCubit(storage);

      await cubit.setThemeMode(ThemeMode.light);
      expect(cubit.state.themeMode, ThemeMode.light);
      expect(storage.getString(SettingsCubit.themeModeKey), 'light');

      await cubit.setThemeMode(ThemeMode.dark);
      expect(cubit.state.themeMode, ThemeMode.dark);
      expect(storage.getString(SettingsCubit.themeModeKey), 'dark');

      await cubit.setThemeMode(ThemeMode.system);
      expect(cubit.state.themeMode, ThemeMode.system);
      expect(storage.getString(SettingsCubit.themeModeKey), 'system');
    });

    test('setLocale updates state and saves to storage', () async {
      cubit = SettingsCubit(storage);

      await cubit.setLocale(const Locale('en'));
      expect(cubit.state.locale, const Locale('en'));
      expect(storage.getString(SettingsCubit.languageCodeKey), 'en');

      await cubit.setLocale(const Locale('ar'));
      expect(cubit.state.locale, const Locale('ar'));
      expect(storage.getString(SettingsCubit.languageCodeKey), 'ar');

      await cubit.setLocale(null);
      expect(cubit.state.locale, isNull);
      expect(storage.containsKey(SettingsCubit.languageCodeKey), isFalse);
    });
  });
}
