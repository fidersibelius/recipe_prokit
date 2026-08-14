import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../shared/widgets/BTScaffold.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AdminQrScreen extends StatelessWidget {
  final Uint8List qrBytes;
  final String texto;
  final String folio;
  final String nombreAsistente;

  const AdminQrScreen({
    super.key,
    required this.qrBytes,
    required this.texto,
    required this.folio,
    required this.nombreAsistente,
  });

  String get mensajeCompartir {
    return texto.replaceAll('{folio}', folio).replaceAll(
          '{nombre_asistente}',
          nombreAsistente,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BTScaffold(
      title: "Boleto creado",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.memory(
              qrBytes,
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'images/no_image.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No fue posible cargar el código QR.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => compartirQr(context),
              icon: const Icon(Icons.share),
              label: const Text("Compartir"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> compartirQr(BuildContext context) async {
    final tempDir = await getTemporaryDirectory();

    final file = File(
      '${tempDir.path}/boleto_qr.png',
    );

    await file.writeAsBytes(qrBytes);

    await Share.shareXFiles(
      [
        XFile(file.path),
      ],
      text: mensajeCompartir,
    );

    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
