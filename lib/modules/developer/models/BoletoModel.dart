class BoletoModel {
  final String boletoUid;
  final String folio;
  final String quienRegistro;
  final String nombre;

  final int checkIn;
  final String fechaCreacion;
  final String? fechaCheckIn;
  final int intentos;

  BoletoModel({
    required this.boletoUid,
    required this.folio,
    required this.quienRegistro,
    required this.nombre,
    required this.checkIn,
    required this.fechaCreacion,
    required this.fechaCheckIn,
    required this.intentos,
  });

  factory BoletoModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BoletoModel(
      boletoUid: json['boleto_uid'] ?? "",
      folio: json['folio'] ?? "",
      quienRegistro: json['quien_registro'] ?? "",
      nombre: json['nombre'] ?? "",
      checkIn: json['check_in'] ?? 0,
      fechaCreacion: json['fecha_creacion'] ?? "",
      fechaCheckIn: json['fecha_check_in'],
      intentos: json['intentos'] ?? 0,
    );
  }
}
