import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/AdminEventosResponseModel.dart';
import '../../../services/ApiClient.dart';

class AdminEventoService {
  static final String _baseUrl = dotenv.env['BASE_URL']!;

  /// ============================
  /// LISTAR EVENTOS
  /// ============================
  static Future<AdminEventosResponseModel?> listarEventos() async {
    try {
      final token = await ApiClient.requireToken();

      if (token == null) {
        return null;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/tickets/eventos/listado'),
        headers: {
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (await ApiClient.handleUnauthorized(response)) {
        return null;
      }

      if (kDebugMode) {
        final preview = response.body.length > 500
            ? '${response.body.substring(0, 500)}...'
            : response.body;

        debugPrint(
          'LISTAR EVENTOS URL: $_baseUrl/tickets/eventos/listado',
        );
        debugPrint(
          'LISTAR EVENTOS STATUS: ${response.statusCode}',
        );
        debugPrint(
          'LISTAR EVENTOS RESPONSE: $preview',
        );
      }

      if (response.statusCode == 200) {
        return AdminEventosResponseModel.fromJson(
          jsonDecode(response.body),
        );
      }
    } catch (e) {
      debugPrint('ERROR LISTAR EVENTOS: $e');
    }

    return null;
  }
}
