import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SessionService {
  final SecureStorageService _secureStorage;

  SessionService(this._secureStorage);

  Future<void> setRememberMe(bool value) async {
    await _secureStorage.save(
      AppConstants.rememberMeKey,
      value.toString(),
    );
  }

  Future<bool> isRemembered() async {
    final value = await _secureStorage.get(
      AppConstants.rememberMeKey,
    );

    return value == 'true';
  }

  Future<void> setGuestMode(bool value) async {
    await _secureStorage.save(
      AppConstants.guestModeKey,
      value.toString(),
    );
  } 

  Future<bool> isGuest() async {
    final value = await _secureStorage.get(
      AppConstants.guestModeKey,
    );

    return value == 'true';
  }

  Future<void> saveToken(String token) async {
    await _secureStorage.save(
      AppConstants.storageTokenKey,
      token,
    );
  }

  Future<String> getToken() async {
    return await _secureStorage.get(
      AppConstants.storageTokenKey,
    );
  }

  Future<void> clearSession() async {
    await _secureStorage.delete(
      AppConstants.storageTokenKey,
    );

    await _secureStorage.delete(
      AppConstants.rememberMeKey,
    );

    await _secureStorage.delete(
      AppConstants.guestModeKey,
    );
  }
}