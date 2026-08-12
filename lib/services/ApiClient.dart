import 'dart:convert';

import 'package:bitsoftickets/screens/RCSignUpScreen.dart';
import 'package:bitsoftickets/utils/NavigationService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'AuthStorage.dart';

class ApiClient {
  static String get baseUrl => dotenv.env['BASE_URL']!;

  // Evita abrir varias pantallas de login si varias peticiones
  // reciben 401 al mismo tiempo.
  static bool _cerrandoSesion = false;

  static Future<Map<String, String>?> getHeaders({
    String accept = 'application/json',
  }) async {
    final token = await requireToken();

    if (token == null) {
      return null;
    }

    return {
      'Accept': accept,
      'Authorization': 'Bearer $token',
    };
  }

  static Future<dynamic> get(String endpoint) async {
    final headers = await getHeaders();

    if (headers == null) {
      throw Exception('TOKEN_INVALIDO');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
    );

    return handleJsonResponse(response);
  }

  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final headers = await getHeaders();

    if (headers == null) {
      throw Exception('TOKEN_INVALIDO');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        ...headers,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    return handleJsonResponse(response);
  }

  /// Debe llamarse también desde servicios que usan http directamente.
  ///
  /// Retorna true si la sesión era inválida y ya inició el cierre.
  static Future<bool> handleUnauthorized(
    http.Response response,
  ) async {
    if (response.statusCode == 401) {
      await _logout();
      return true;
    }

    final jsonData = _tryDecodeJson(response.body);

    if (_respuestaIndicaTokenInvalido(jsonData)) {
      await _logout();
      return true;
    }

    return false;
  }

  static Future<dynamic> handleJsonResponse(
    http.Response response,
  ) async {
    if (await handleUnauthorized(response)) {
      throw Exception('TOKEN_INVALIDO');
    }

    final jsonData = _tryDecodeJson(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        _obtenerMensajeError(jsonData),
      );
    }

    if (jsonData == null) {
      throw Exception(
        'La respuesta del servidor no contiene JSON válido.',
      );
    }

    return jsonData;
  }

  /// Para respuestas de imágenes, archivos o multipart.
  static Future<Uint8List?> handleBytesResponse(
    http.Response response,
  ) async {
    if (await handleUnauthorized(response)) {
      throw Exception('TOKEN_INVALIDO');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final jsonData = _tryDecodeJson(response.body);

      throw Exception(
        _obtenerMensajeError(jsonData),
      );
    }

    if (response.bodyBytes.isEmpty) {
      return null;
    }

    return response.bodyBytes;
  }

  static dynamic _tryDecodeJson(String body) {
    if (body.trim().isEmpty) {
      return null;
    }

    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }

  static bool _respuestaIndicaTokenInvalido(
    dynamic jsonData,
  ) {
    if (jsonData is! Map) {
      return false;
    }

    if (jsonData['status'] != false) {
      return false;
    }

    final mensaje =
        (jsonData['message'] ?? jsonData['msg'] ?? '').toString().toLowerCase();

    return mensaje.contains('token') &&
        (mensaje.contains('inválido') ||
            mensaje.contains('invalido') ||
            mensaje.contains('expirado') ||
            mensaje.contains('expired') ||
            mensaje.contains('unauthenticated'));
  }

  static String _obtenerMensajeError(
    dynamic jsonData,
  ) {
    if (jsonData is Map) {
      return (jsonData['message'] ?? jsonData['msg'] ?? 'Error en API')
          .toString();
    }

    return 'Error en API';
  }

  static Future<void> _logout() async {
    if (_cerrandoSesion) {
      return;
    }

    _cerrandoSesion = true;

    try {
      await AuthStorage.clear();

      final navigator = globalNavigatorKey.currentState;

      if (navigator == null) {
        debugPrint(
          'No fue posible navegar al login: Navigator no disponible.',
        );
        return;
      }

      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => RCSignUpScreen(
            selectedIndex: 1,
          ),
        ),
        (route) => false,
      );
    } finally {
      // Dejamos tiempo para que termine la navegación.
      Future<void>.delayed(
        const Duration(seconds: 1),
        () {
          _cerrandoSesion = false;
        },
      );
    }
  }

  static Future<void> logout() async {
    await _logout();
  }

  static Future<String?> requireToken() async {
    final token = await AuthStorage.getToken();

    if (token == null || token.trim().isEmpty) {
      await _logout();
      return null;
    }

    return token;
  }
}
