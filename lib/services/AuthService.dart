import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'AuthStorage.dart';

class AuthService {
  static Future<bool> login(
    String username,
    String password,
  ) async {
    final baseUrl = dotenv.env['BASE_URL']!;

    final response = await http.post(
      Uri.parse('$baseUrl/tickets/login'),
      body: {
        "username": username,
        "password": password,
      },
    );

    final jsonData = jsonDecode(response.body);

    if (jsonData['status'] == true) {
      await AuthStorage.saveToken(
        jsonData['token_jwt'],
      );

      await AuthStorage.saveRole(
        jsonData['role_id'],
      );
      print("ROLE: ${jsonData['role_id']}");
      print("LOGO BITSOF: ${jsonData['logo_bitsofmx']}");
      print("LOGO ORG: ${jsonData['logo_org']}");
      print("EVENTO: ${jsonData['evento_nombre']}");
      print("IMAGEN: ${jsonData['evento_imagen']}");
      await AuthStorage.saveEvento(
        logoBitsof: jsonData['logo_bitsofmx'] ?? "",
        logoOrg: jsonData['logo_org'] ?? "",
        nombre: jsonData['evento_nombre'] ?? "",
        imagen: jsonData['evento_imagen'] ?? "",
      );

      return true;
    }

    return false;
  }
}
