import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'AuthStorage.dart';

class AuthService {
  static Future<bool> login(
    String username,
    String password,
  ) async {
    try {
      final baseUrl = dotenv.env['BASE_URL']!;

      print("LOGIN 1");
      print("$baseUrl/tickets/login");

      final response = await http.post(
        Uri.parse('$baseUrl/tickets/login'),
        body: {
          "username": username,
          "password": password,
        },
      );

      print("LOGIN 2");
      print(response.statusCode);
      print(response.body);

      final jsonData = jsonDecode(response.body);

      if (jsonData['status'] == true) {
        print("LOGIN 3");

        await AuthStorage.saveToken(
          jsonData['token_jwt'],
        );

        print("LOGIN 4");

        await AuthStorage.saveRole(
          jsonData['role_id'],
        );

        print("LOGIN 5");

        await AuthStorage.saveEvento(
          logoBitsof: jsonData['logo_bitsofmx'] ?? "",
          logoOrg: jsonData['logo_org'] ?? "",
          nombre: jsonData['evento_nombre'] ?? "",
          imagen: jsonData['evento_imagen'] ?? "",
        );

        print("LOGIN 6");

        return true;
      }

      print("LOGIN STATUS FALSE");
      return false;
    } catch (e, s) {
      print("ERROR LOGIN");
      print(e);
      print(s);
    }

    return false;
  }
}
