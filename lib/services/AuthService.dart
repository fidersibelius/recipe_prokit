import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/AccessCapabilities.dart';
import 'AuthStorage.dart';

class AuthService {
  static Future<bool> login(
    String username,
    String password,
  ) async {
    try {
      final baseUrl = dotenv.env['BASE_URL']!;

      final response = await http.post(
        Uri.parse('$baseUrl/tickets/login'),
        body: {
          "username": username,
          "password": password,
        },
      );

      if (kDebugMode) {
        debugPrint('LOGIN STATUS HTTP: ${response.statusCode}');
      }

      final jsonData = jsonDecode(response.body);

      if (jsonData is Map<String, dynamic> && jsonData['status'] == true) {
        final token = jsonData['token_jwt']?.toString() ?? '';

        if (token.isEmpty) {
          return false;
        }

        await AuthStorage.saveToken(
          token,
        );

        await AuthStorage.saveRole(
          int.tryParse(jsonData['role_id']?.toString() ?? '') ?? 0,
        );

        await AuthStorage.saveCapabilities(
          AccessCapabilities.fromLoginJson(jsonData),
        );

        await AuthStorage.saveEvento(
          logoBitsof:
              jsonData['logo_bitsofm'] ?? jsonData['logo_bitsofmx'] ?? "",
          logoOrg: jsonData['logo_org'] ?? "",
          nombre: jsonData['evento_nombre'] ?? "",
          imagen: jsonData['evento_imagen'] ?? "",
        );

        return true;
      }

      return false;
    } catch (e, s) {
      debugPrint('ERROR LOGIN: $e');
      debugPrintStack(stackTrace: s);
    }

    return false;
  }
}
