import '../storage/secure_storage.dart';

class TokenService {
  final SecureStorage _storage;

  const TokenService(this._storage);

  Future<String?> getToken() {
    return _storage.getToken();
  }

  Future<void> saveToken(String token) {
    return _storage.saveToken(token);
  }

  Future<void> deleteToken() {
    return _storage.deleteToken();
  }
}