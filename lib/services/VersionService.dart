import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recipe_prokit/services/ApiClient.dart';

class VersionService {
  static Future<dynamic> cargaInicial() async {
    final version = dotenv.env['APP_VERSION'] ?? '1.0.0';

    return await ApiClient.post(
      'tickets/carga_inicial/$version',
      {},
    );
  }
}
