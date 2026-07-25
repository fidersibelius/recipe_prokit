import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../services/AuthStorage.dart';
import '../models/BoletosResponseModel.dart';
import 'dart:typed_data';

class BoletoService {
  static final String _baseUrl = dotenv.env['BASE_URL']!;

  /// ============================
  /// LISTAR BOLETOS
  /// ============================
  static Future<BoletosResponseModel?> listarBoletos(
    String uid,
  ) async {
    try {
      final token = await AuthStorage.getToken();

      final response = await http.post(
        Uri.parse(
          '$_baseUrl/tickets/eventos/$uid/boletos/listado',
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return BoletosResponseModel.fromJson(
          jsonDecode(response.body),
        );
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  /// ============================
  /// CREAR BOLETO
  /// ============================
  static Future<Uint8List?> crearBoleto(
    String uid,
    String nombre,
  ) async {
    try {
      final token = await AuthStorage.getToken();

      final response = await http.post(
        Uri.parse(
          '$_baseUrl/tickets/eventos/$uid/boletos/crear',
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
        body: {
          "nombre": nombre,
        },
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}
