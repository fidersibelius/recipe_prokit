import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyToken = "jwt_token";
  static const _keyUser = "username";
  static const _keyFirstTime = "first_time";

  /// 🔑 GUARDAR TOKEN
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// 👤 GUARDAR USUARIO
  static Future<void> saveUser(String user) async {
    await _storage.write(key: _keyUser, value: user);
  }

  /// 🔍 OBTENER TOKEN
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  /// 👤 OBTENER USUARIO
  static Future<String?> getUser() async {
    return await _storage.read(key: _keyUser);
  }

  /// ❌ BORRAR TOKEN (logout)
  static Future<void> clear() async {
    await _storage.deleteAll();
  }

  /// 🧠 PRIMERA VEZ
  static Future<bool> isFirstTime() async {
    final value = await _storage.read(key: _keyFirstTime);
    return value == null;
  }

  static Future<void> setNotFirstTime() async {
    await _storage.write(key: _keyFirstTime, value: "false");
  }
}
