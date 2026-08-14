import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/AdminEventosResponseModel.dart';
import '../../../services/AuthStorage.dart';
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
          "Authorization": "Bearer $token",
        },
      );

      if (await ApiClient.handleUnauthorized(response)) {
        return null;
      }

      print(response.body);
      if (response.statusCode == 200) {
        return AdminEventosResponseModel.fromJson(
          jsonDecode(response.body),
        );
      }
    } catch (e) {
      print("AdminEventoService.listarEventos()");
      print(e);
    }

    return null;
  }
}
