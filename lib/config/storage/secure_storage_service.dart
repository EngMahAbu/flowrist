import 'package:flowrist/config/storage/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService implements SecureStorage {
  final FlutterSecureStorage _secureStorage;
  static const String _tokenKey = 'token';
  SecureStorageService(this._secureStorage);

  @override
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }
}