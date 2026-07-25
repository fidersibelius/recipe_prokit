class LoginResponseModel {
  final bool status;
  final String tokenJwt;
  final int roleId;
  final String logoBitsofmx;

  LoginResponseModel({
    required this.status,
    required this.tokenJwt,
    required this.roleId,
    required this.logoBitsofmx,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'] ?? false,
      tokenJwt: json['token_jwt'] ?? '',
      roleId: json['role_id'] ?? 0,
      logoBitsofmx: json['logo_bitsofmx'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'token_jwt': tokenJwt,
      'role_id': roleId,
      'logo_bitsofmx': logoBitsofmx,
    };
  }
}
