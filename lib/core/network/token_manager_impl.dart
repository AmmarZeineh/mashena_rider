import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'token_manager.dart';

final class TokenManagerImpl implements TokenManager {
  TokenManagerImpl(this._storage);

  final FlutterSecureStorage _storage;

  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';

  String? _accessToken;
  String? _refreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    _accessToken = accessToken;
    await _storage.write(key: _kAccess, value: accessToken);

    if (refreshToken != null) {
      _refreshToken = refreshToken;
      await _storage.write(key: _kRefresh, value: refreshToken);
    }
  }

  @override
  Future<String?> getAccessToken() async {
    if (_accessToken != null) return _accessToken;
    _accessToken = await _storage.read(key: _kAccess);
    return _accessToken;
  }

  @override
  Future<String?> getRefreshToken() async {
    if (_refreshToken != null) return _refreshToken;
    _refreshToken = await _storage.read(key: _kRefresh);
    return _refreshToken;
  }

  @override
  Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }
}
