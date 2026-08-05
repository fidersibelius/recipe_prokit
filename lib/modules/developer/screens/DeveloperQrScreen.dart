import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../shared/widgets/BTScaffold.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DeveloperQrScreen extends StatelessWidget {
  final Uint8List qrBytes;

  const DeveloperQrScreen({
    super.key,
    required this.qrBytes,
  });

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
              onPressed: compartirQr,
              icon: const Icon(Icons.share),
              label: const Text("Compartir"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> compartirQr() async {
    final tempDir = await getTemporaryDirectory();

    final file = File(
      '${tempDir.path}/boleto_qr.png',
    );

    await file.writeAsBytes(qrBytes);

    await Share.shareXFiles(
      [
        XFile(file.path),
      ],
      text: 'Tu boleto para el evento.',
    );
  }
}
