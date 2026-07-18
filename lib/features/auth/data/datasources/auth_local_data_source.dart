import 'dart:convert';

import 'package:mashena_rider/core/network/token_manager.dart';
import 'package:mashena_rider/core/storage/local_storage.dart';
import 'package:mashena_rider/features/auth/data/models/login_user_dto.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheSession({
    required String accessToken,
    required String refreshToken,
    required LoginUserDto user,
  });

  Future<String?> getCachedAccessToken();
  Future<LoginUserDto?> getCachedUser();

  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage, this._tokenManager);

  final LocalStorage _storage;
  final TokenManager _tokenManager;

  static const _kUserKey = 'auth.cached_user';

  @override
  Future<void> cacheSession({
    required String accessToken,
    required String refreshToken,
    required LoginUserDto user,
  }) async {
    await _tokenManager.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    await _storage.setString(_kUserKey, jsonEncode(user.toJson()));
  }

  @override
  Future<String?> getCachedAccessToken() {
    return _tokenManager.getAccessToken();
  }

  @override
  Future<LoginUserDto?> getCachedUser() async {
    final raw = _storage.getString(_kUserKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      return LoginUserDto.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // لو صار corruption بالكاش امسحو
      await _storage.remove(_kUserKey);
      return null;
    }
  }

  @override
  Future<void> clearSession() async {
    await _tokenManager.clearTokens();
    await _storage.remove(_kUserKey);
  }
}
