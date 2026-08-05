class BoletoModel {
  final String boletoUid;
  final String fechaCreacion;
  final String quienRegistro;
  final String nombre;
  final int checkIn;
  final String? fechaCheckIn;
  final int intentos;

  BoletoModel({
    required this.boletoUid,
    required this.fechaCreacion,
    required this.quienRegistro,
    required this.nombre,
    required this.checkIn,
    required this.fechaCheckIn,
    required this.intentos,
  });

  factory BoletoModel.fromJson(Map<String, dynamic> json) {
    return BoletoModel(
      boletoUid: json['boleto_uid'] ?? '',
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
      'boleto_uid': boletoUid,
      'fecha_creacion': fechaCreacion,
      'quien_registro': quienRegistro,
      'nombre': nombre,
      'check_in': checkIn,
      'fecha_check_in': fechaCheckIn,
      'intentos': intentos,
    };
  }
}
