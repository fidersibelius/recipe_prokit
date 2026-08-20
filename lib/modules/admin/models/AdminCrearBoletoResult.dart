import 'dart:typed_data';

class AdminCrearBoletoResult {
  final Uint8List? qrBytes;
  final String? errorMessage;
  final String? fileName;

  const AdminCrearBoletoResult.success(
    Uint8List this.qrBytes,
    this.fileName,
  ) : errorMessage = null;

  const AdminCrearBoletoResult.failure(
    String this.errorMessage,
  )   : qrBytes = null,
        fileName = null;

  bool get success => qrBytes != null && qrBytes!.isNotEmpty;
}
