import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../shared/widgets/BTScaffold.dart';
import 'package:share_plus/share_plus.dart';

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

  Future<void> compartirQr(
    BuildContext context,
  ) async {
    try {
      final renderBox = context.findRenderObject() as RenderBox?;

      final nombreArchivo =
          folio.trim().isEmpty ? 'boleto_qr.png' : 'boleto_${folio.trim()}.png';

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              qrBytes,
              mimeType: 'image/png',
              name: nombreArchivo,
            ),
          ],
          text: mensajeCompartir,
          subject: folio.trim().isEmpty ? 'Boleto' : 'Boleto ${folio.trim()}',
          sharePositionOrigin: renderBox == null
              ? null
              : renderBox.localToGlobal(
                    Offset.zero,
                  ) &
                  renderBox.size,
        ),
      );

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint(
        'ERROR COMPARTIR QR: $e',
      );

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No fue posible compartir el boleto.',
          ),
        ),
      );
    }
  }
}
