import 'AdminBoletoModel.dart';

class AdminBoletosResponseModel {
  final bool status;
  final List<AdminBoletoModel> boletos;

  AdminBoletosResponseModel({
    required this.status,
    required this.boletos,
  });

  factory AdminBoletosResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminBoletosResponseModel(
      status: (json['status'] ?? json['estatus'] ?? false) as bool,
      boletos: ((json['boletos'] ?? []) as List)
          .map((e) => AdminBoletoModel.fromJson(e))
          .toList(),
    );
  }
}
