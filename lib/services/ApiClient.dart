import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_prokit/screens/RCSignUpScreen.dart';

import 'AuthStorage.dart';
import 'package:recipe_prokit/utils/NavigationService.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static String get baseUrl => dotenv.env['BASE_URL']!;

  /// 🔑 HEADERS AUTOMÁTICOS
  static Future<Map<String, String>> _getHeaders() async {
    String? token;

    if (!kIsWeb) {
      token = await AuthStorage.getToken();
    }

    Map<String, String> headers = {
      "Accept": "application/json",
    };

    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    return headers;
  }

  /// 📥 GET
  static Future<dynamic> get(String endpoint) async {
    final headers = await _getHeaders();

    print("🔗 URL: $baseUrl/$endpoint");

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
    );

    print("📡 Status: ${response.statusCode}");

    return await _handleResponse(response);
  }

  /// 📤 POST
  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    print("🔗 URL: $baseUrl/$endpoint");

    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        ...(await _getHeaders()),
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("📡 Status: ${response.statusCode}");

    return await _handleResponse(response);
  }

  /// 🧠 MANEJO GLOBAL
  static Future<dynamic> _handleResponse(
    http.Response response,
  ) async {
    final jsonData = jsonDecode(response.body);

    /// 🔥 TOKEN INVÁLIDO HTTP
    if (response.statusCode == 401) {
      await _logout();

      throw Exception("TOKEN_INVALIDO");
    }

    /// 🔥 TOKEN EXPIRADO CUSTOM API
    if (jsonData is Map &&
        jsonData['status'] == false &&
        jsonData['msg'].toString().toLowerCase().contains('token')) {
      await _logout();

      throw Exception("TOKEN_INVALIDO");
    }

    /// 🔥 ERROR GENERAL
    if (response.statusCode != 200) {
      if (jsonData is Map) {
        throw Exception(
          jsonData['message'] ?? jsonData['msg'] ?? "Error en API",
        );
      }

      throw Exception("Error en API");
    }

    return jsonData;
  }

  /// 🚪 LOGOUT GLOBAL
  static Future<void> _logout() async {
    await AuthStorage.clear();

    globalNavigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => RCSignUpScreen(selectedIndex: 1),
      ),
      (route) => false,
    );
  }

  static Future<void> logout() async {
    await _logout();
  }

  /// 🔥 MULTIPART RESPONSE
  static Future<dynamic> handleMultipartResponse(
    http.Response response,
  ) async {
    final jsonData = jsonDecode(response.body);

    /// 🔥 TOKEN INVÁLIDO
    if (response.statusCode == 401) {
      await _logout();

      throw Exception("TOKEN_INVALIDO");
    }

    /// 🔥 ERROR GENERAL
    if (response.statusCode != 200) {
      if (jsonData is Map) {
        throw Exception(
          jsonData['message'] ?? jsonData['msg'] ?? "Error en API",
        );
      }

      throw Exception("Error en API");
    }

    return jsonData;
  }
}
