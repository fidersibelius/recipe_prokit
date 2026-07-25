import 'EventoModel.dart';

class EventosResponseModel {
  final bool status;
  final List<EventoModel> eventos;

  EventosResponseModel({
    required this.status,
    required this.eventos,
  });

  factory EventosResponseModel.fromJson(Map<String, dynamic> json) {
    return EventosResponseModel(
      // Acepta "status" o "estatus"
      status: (json['status'] ?? json['estatus'] ?? false) as bool,

      // Si no viene la lista, regresa una lista vacía
      eventos: ((json['eventos'] ?? []) as List)
          .map((e) => EventoModel.fromJson(e))
          .toList(),
    );
  }
}
