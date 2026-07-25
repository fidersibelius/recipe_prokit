import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../services/AuthStorage.dart';

class QRService {
  static final String _baseUrl = dotenv.env['BASE_URL']!;

  static Future<Uint8List?> generarQR(
    String nombre,
  ) async {
    try {
      final token = await AuthStorage.getToken();

      final response = await http.post(
        Uri.parse(
          '$_baseUrl/tickets/genera_qr',
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
