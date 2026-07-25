class BoletoModel {
  final String fechaCreacion;
  final String quienRegistro;
  final String nombre;
  final int checkIn;
  final String? fechaCheckIn;
  final int intentos;

  BoletoModel({
    required this.fechaCreacion,
    required this.quienRegistro,
    required this.nombre,
    required this.checkIn,
    required this.fechaCheckIn,
    required this.intentos,
  });

  factory BoletoModel.fromJson(Map<String, dynamic> json) {
    return BoletoModel(
      fechaCreacion: json['fecha_creacion'] ?? '',
      quienRegistro: json['quien_registro'] ?? '',
      nombre: json['nombre'] ?? '',
      checkIn: json['check_in'] ?? 0,
      fechaCheckIn: json['fecha_check_in'],
      intentos: json['intentos'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fecha_creacion': fechaCreacion,
      'quien_registro': quienRegistro,
      'nombre': nombre,
      'check_in': checkIn,
      'fecha_check_in': fechaCheckIn,
      'intentos': intentos,
    };
  }
}
