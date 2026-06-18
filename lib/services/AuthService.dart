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

      return true;
    }

    return false;
  }
}
