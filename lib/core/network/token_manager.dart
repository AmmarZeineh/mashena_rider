abstract class TokenManager {
  Future<void> saveTokens({required String accessToken, String? refreshToken});

  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<bool> hasToken();
  Future<void> clearTokens();
}
