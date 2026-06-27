import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'token';
  static const _refreshTokenKey = 'refreshToken';
  static const _userIdKey = 'userId';
  static const _passwordKey = 'password';
  static const _expirationKey = 'expiration';
  // Save
  static Future<void> saveAuthData({
    required String token,
    required String refreshToken,
    required int userId,
    required DateTime expiration,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _userIdKey, value: userId.toString());
    await _storage.write(
      key: _expirationKey,
      value: expiration.toIso8601String(),
    );
  }

  static Future<void> savePassword(String password) async {
    await _storage.write(key: _passwordKey, value: password);
  }

  static Future<String?> getPassword() async {
    return await _storage.read(key: _passwordKey);
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Get token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Get refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  static Future<DateTime?> getExpiration() async {
    final expiration = await _storage.read(key: _expirationKey);
    if (expiration == null) return null;

    return DateTime.parse(expiration);
  }

  // Clear (logout)
  static Future<void> clear() async {
    await _storage.deleteAll();
  }

  static Future<void> deletePassword() async {
    await _storage.delete(key: _passwordKey);
  }

  static Future<int?> getUserId() async {
    final id = await _storage.read(key: _userIdKey);
    return id != null ? int.tryParse(id) : null;
  }
}
