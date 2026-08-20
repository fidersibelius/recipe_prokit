import '../../../services/ApiClient.dart';

class CheckerTicketService {
  static Future<dynamic> registrarIngreso(
    String codigo,
  ) async {
    return ApiClient.postMultipart(
      'tickets/boletos/registra_ingreso',
      {
        'codigo': codigo,
      },
    );
  }
}
