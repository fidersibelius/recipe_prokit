import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../services/ApiClient.dart';

import '../models/AdminBoletosResponseModel.dart';
import '../models/AdminCrearBoletoResult.dart';
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
  static Future<AdminCrearBoletoResult> crearBoleto(
    String uid,
    String nombre,
  ) async {
    try {
      final token = await ApiClient.requireToken();

      if (token == null) {
        return const AdminCrearBoletoResult.failure(
          'La sesión no es válida.',
        );
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
        return const AdminCrearBoletoResult.failure(
          'La sesión expiró.',
        );
      }

      debugPrint(
        'CREAR BOLETO STATUS: ${response.statusCode}',
      );

      debugPrint(
        'CREAR BOLETO CONTENT-TYPE: '
        '${response.headers['content-type']}',
      );

      final respuestaExitosa =
          response.statusCode == 200 || response.statusCode == 201;

      if (respuestaExitosa && _esPng(response.bodyBytes)) {
        return AdminCrearBoletoResult.success(
          response.bodyBytes,
          _obtenerNombreArchivo(response),
        );
      }

      final mensaje = _obtenerMensajeError(response);

      debugPrint(
        'ERROR CREAR BOLETO: $mensaje',
      );

      return AdminCrearBoletoResult.failure(mensaje);
    } catch (e, stackTrace) {
      debugPrint(
        'EXCEPCIÓN CREAR BOLETO: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      return const AdminCrearBoletoResult.failure(
        'No fue posible comunicarse con el servidor.',
      );
    }
  }

  static bool _esPng(Uint8List bytes) {
    return bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A;
  }

  static String _obtenerMensajeError(http.Response response) {
    if (response.body.trim().isNotEmpty) {
      try {
        final jsonData = jsonDecode(response.body);

        if (jsonData is Map) {
          return (jsonData['error_msg'] ??
                  jsonData['message'] ??
                  jsonData['msg'] ??
                  jsonData['error'] ??
                  'No fue posible crear el boleto.')
              .toString();
        }
      } catch (_) {
        // La respuesta no era JSON; se usa un mensaje controlado.
      }
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return 'Error del servidor (${response.statusCode}).';
    }

    return 'El servidor no devolvió un código QR válido.';
  }

  static String? _obtenerNombreArchivo(http.Response response) {
    final contentDisposition = response.headers['content-disposition'];

    if (contentDisposition == null || contentDisposition.trim().isEmpty) {
      return null;
    }

    final utf8Match = RegExp(
      r"filename\*=UTF-8''([^;]+)",
      caseSensitive: false,
    ).firstMatch(contentDisposition);

    final regularMatch = RegExp(
      r'filename="?([^";]+)"?',
      caseSensitive: false,
    ).firstMatch(contentDisposition);

    final encodedName = utf8Match?.group(1) ?? regularMatch?.group(1);

    if (encodedName == null || encodedName.trim().isEmpty) {
      return null;
    }

    try {
      return Uri.decodeComponent(encodedName.trim());
    } catch (_) {
      return encodedName.trim();
    }
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
