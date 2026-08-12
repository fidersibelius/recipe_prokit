class EventoModel {
  final String uid;
  final String nombre;
  final String logoOrg;
  final String eventoImagen;
  final String fechaIni;
  final String fechaFin;
  final int isActive;
  final int boletos;
  final String texto;

  EventoModel({
    required this.uid,
    required this.nombre,
    required this.logoOrg,
    required this.eventoImagen,
    required this.fechaIni,
    required this.fechaFin,
    required this.isActive,
    required this.boletos,
    required this.texto,
  });

  factory EventoModel.fromJson(Map<String, dynamic> json) {
    return EventoModel(
      uid: json['uid'] ?? '',
      nombre: json['nombre'] ?? '',
      logoOrg: json['logo_org'] ?? '',
      eventoImagen: json['evento_imagen'] ?? '',
      fechaIni: json['fecha_ini'] ?? '',
      fechaFin: json['fecha_fin'] ?? '',
      isActive: json['is_active'] ?? 0,
      boletos: json['boletos'] ?? 0,
      texto: json['texto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nombre': nombre,
      'logo_org': logoOrg,
      'evento_imagen': eventoImagen,
      'fecha_ini': fechaIni,
      'fecha_fin': fechaFin,
      'is_active': isActive,
      'boletos': boletos,
      'texto': texto,
    };
  }
}
