import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (scanned) return;

          scanned = true;

          final barcode = capture.barcodes.first;

          final code = barcode.rawValue;

          print('QR LEIDO: $code');

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('QR Detectado'),
              content: Text(code ?? 'Sin datos'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    scanned = false;
                  },
                  child: const Text('Cerrar'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
