import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/storage/local_storage.dart';
import 'package:mashena_rider/features/settings/presentation/cubits/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final LocalStorage _localStorage;

  static const String themeModeKey = 'app_theme_mode';
  static const String languageCodeKey = 'app_language_code';

  SettingsCubit(this._localStorage) : super(const SettingsState()) {
    _loadPreferences();
  }

  void _loadPreferences() {
    final storedTheme = _localStorage.getString(themeModeKey);
    final themeMode = _parseThemeMode(storedTheme);

    final storedLang = _localStorage.getString(languageCodeKey);
    final locale = (storedLang != null && storedLang.isNotEmpty)
        ? Locale(storedLang)
        : null;

    emit(SettingsState(themeMode: themeMode, locale: locale));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    final value = switch (mode) {
      ThemeMode.system => 'system',
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
    };
    await _localStorage.setString(themeModeKey, value);
  }

  Future<void> setLocale(Locale? locale) async {
    if (locale == null) {
      emit(state.copyWith(clearLocale: true));
      await _localStorage.remove(languageCodeKey);
    } else {
      emit(state.copyWith(locale: locale));
      await _localStorage.setString(languageCodeKey, locale.languageCode);
    }
  }

  ThemeMode _parseThemeMode(String? value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
