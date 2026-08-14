import 'AdminEventoModel.dart';

class AdminEventosResponseModel {
  final bool status;
  final List<AdminEventoModel> eventos;

  AdminEventosResponseModel({
    required this.status,
    required this.eventos,
  });

  factory AdminEventosResponseModel.fromJson(Map<String, dynamic> json) {
    return AdminEventosResponseModel(
      // Acepta "status" o "estatus"
      status: (json['status'] ?? json['estatus'] ?? false) as bool,

      // Si no viene la lista, regresa una lista vacía
      eventos: ((json['eventos'] ?? []) as List)
          .map((e) => AdminEventoModel.fromJson(e))
          .toList(),
    );
  }
}
