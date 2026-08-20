class AccessCapabilities {
  final bool esAdmin;
  final bool esChecker;
  final bool esDemo;

  const AccessCapabilities({
    required this.esAdmin,
    required this.esChecker,
    required this.esDemo,
  });

  factory AccessCapabilities.fromLoginJson(
    Map<String, dynamic> json,
  ) {
    return AccessCapabilities(
      esAdmin: parseApiBool(json['es_admin']),
      esChecker: parseApiBool(json['es_checker']),
      esDemo: parseApiBool(json['es_demo']),
    );
  }

  bool get hasAccess => esAdmin || esChecker;

  String get roleLabel {
    if (esAdmin && esChecker) {
      return 'Admin y Checker';
    }

    if (esAdmin) {
      return 'Admin';
    }

    if (esChecker) {
      return 'Checker';
    }

    return 'Sin permisos';
  }

  static bool parseApiBool(dynamic value) {
    if (value == true || value == 1) {
      return true;
    }

    final normalized = value?.toString().trim().toLowerCase();

    return normalized == '1' || normalized == 'true';
  }
}
