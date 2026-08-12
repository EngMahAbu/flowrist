import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageService {
  late final FlutterSecureStorage _secureStorage;

  SecureStorageService() {
    _secureStorage = FlutterSecureStorage();
  }

  Future<void> save(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<String> get(String key) async {
    return await _secureStorage.read(key: key) ?? '';
  }
}
