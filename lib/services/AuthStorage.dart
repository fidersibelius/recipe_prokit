import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyToken = "jwt_token";
  static const _keyUser = "username";
  static const _keyFirstTime = "first_time";
  static const _keyLogoBitsof = "logo_bitsofmx";
  static const _keyLogoOrg = "logo_org";

  static const _keyEvento = "evento_nombre";
  static const _keyEventoImagen = "evento_imagen";

  /// 🖼️ LOGO BITSOFTICKETS
  static Future<String?> getLogoBitsof() async {
    return await _storage.read(key: _keyLogoBitsof);
  }

  /// 🖼️ LOGO ORGANIZADOR
  static Future<String?> getLogoOrg() async {
    return await _storage.read(key: _keyLogoOrg);
  }

  /// 🎫 OBTENER NOMBRE DEL EVENTO
  static Future<String?> getEvento() async {
    return await _storage.read(key: _keyEvento);
  }

  /// 🖼️ OBTENER IMAGEN DEL EVENTO
  static Future<String?> getEventoImagen() async {
    return await _storage.read(key: _keyEventoImagen);
  }

  /// 🔑 GUARDAR TOKEN
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// 👤 GUARDAR USUARIO
  static Future<void> saveUser(String user) async {
    await _storage.write(key: _keyUser, value: user);
  }

  /// 🎫 GUARDAR DATOS DEL EVENTO
  static Future<void> saveEvento({
    required String logoBitsof,
    required String logoOrg,
    required String nombre,
    required String imagen,
  }) async {
    await _storage.write(
      key: _keyLogoBitsof,
      value: logoBitsof,
    );

    await _storage.write(
      key: _keyLogoOrg,
      value: logoOrg,
    );

    await _storage.write(
      key: _keyEvento,
      value: nombre,
    );

    await _storage.write(
      key: _keyEventoImagen,
      value: imagen,
    );
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
