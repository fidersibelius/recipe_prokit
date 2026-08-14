import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../services/ApiClient.dart';

import '../../../services/AuthStorage.dart';
import '../models/AdminBoletosResponseModel.dart';
import 'dart:typed_data';

class AdminBoletoService {
  static final String _baseUrl = dotenv.env['BASE_URL']!;

  /// ============================
  /// LISTAR BOLETOS
  /// ============================
  static Future<AdminBoletosResponseModel?> listarBoletos(
    String uid,
  ) async {
    try {
      final token = await ApiClient.requireToken();

      if (token == null) {
        return null;
      }

      final response = await http.post(
        Uri.parse(
          '$_baseUrl/tickets/eventos/$uid/boletos/listado',
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (await ApiClient.handleUnauthorized(response)) {
        return null;
      }

      print("STATUS LISTADO: ${response.statusCode}");
      print("BODY LISTADO: ${response.body}");

      if (response.statusCode == 200) {
        return AdminBoletosResponseModel.fromJson(
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
      final token = await ApiClient.requireToken();

      if (token == null) {
        return null;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '$_baseUrl/tickets/eventos/$uid/boletos/crear',
        ),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'image/png',
      });

      request.fields['nombre'] = nombre.trim();

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(
        streamedResponse,
      );

      if (await ApiClient.handleUnauthorized(response)) {
        return null;
      }

      debugPrint(
        'CREAR BOLETO STATUS: ${response.statusCode}',
      );

      debugPrint(
        'CREAR BOLETO CONTENT-TYPE: '
        '${response.headers['content-type']}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.bodyBytes;
      }

      debugPrint(
        'ERROR CREAR BOLETO: ${response.body}',
      );
    } catch (e, stackTrace) {
      debugPrint(
        'EXCEPCIÓN CREAR BOLETO: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    }

    return null;
  }

  /// ============================
  /// OBTENER QR DEL BOLETO
  /// ============================
  static Future<Uint8List?> obtenerQr(
    String eventoUid,
    String boletoUid,
  ) async {
    try {
      final token = await ApiClient.requireToken();

      if (token == null) {
        return null;
      }

      final url = '$_baseUrl/tickets/eventos/$eventoUid/$boletoUid/boletos/qr';

      debugPrint('URL OBTENER QR: $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'image/png',
        },
      );

      if (await ApiClient.handleUnauthorized(response)) {
        return null;
      }

      debugPrint(
        'OBTENER QR STATUS: ${response.statusCode}',
      );

      debugPrint(
        'OBTENER QR CONTENT-TYPE: '
        '${response.headers['content-type']}',
      );

      debugPrint(
        'OBTENER QR BYTES: ${response.bodyBytes.length}',
      );

      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        return response.bodyBytes;
      }

      debugPrint(
        'ERROR OBTENER QR: ${response.body}',
      );
    } catch (e, stackTrace) {
      debugPrint(
        'EXCEPCIÓN OBTENER QR: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    }

    return null;
  }
}
