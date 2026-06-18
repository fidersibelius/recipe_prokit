import 'ApiClient.dart';

class TicketService {
  static Future<dynamic> registrarIngreso(String codigo) async {
    return await ApiClient.post(
      'tickets/registra_ingreso',
      {
        'codigo': codigo,
      },
    );
  }
}
