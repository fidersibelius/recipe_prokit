import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bitsoftickets/services/ApiClient.dart';

class VersionService {
  static Future<dynamic> cargaInicial() async {
    final version = dotenv.env['APP_VERSION'] ?? '1.2.3';

    print("ANTES DEL POST");

    final r = await ApiClient.post(
      'tickets/carga_inicial/$version',
      {},
    );

    print("DESPUES DEL POST");

    print(r);
    print(r["status"]);

    return r;
  }
}
