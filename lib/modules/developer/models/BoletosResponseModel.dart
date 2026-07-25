import 'BoletoModel.dart';

class BoletosResponseModel {
  final bool status;
  final List<BoletoModel> boletos;

  BoletosResponseModel({
    required this.status,
    required this.boletos,
  });

  factory BoletosResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BoletosResponseModel(
      status: (json['status'] ?? json['estatus'] ?? false) as bool,
      boletos: ((json['boletos'] ?? []) as List)
          .map((e) => BoletoModel.fromJson(e))
          .toList(),
    );
  }
}
