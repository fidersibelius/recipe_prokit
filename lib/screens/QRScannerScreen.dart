import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/TicketService.dart';
import 'package:bitsoftickets/screens/QRResultScreen.dart';
import 'package:nb_utils/nb_utils.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          title: const Text('Escanear QR'),
        ),
        body: MobileScanner(
          onDetect: (capture) async {
            if (scanned) return;

            if (capture.barcodes.isEmpty) return;

            final code = capture.barcodes.first.rawValue;

            if (code == null || code.isEmpty) return;

            scanned = true;

            print('QR: $code');

            final resp = await TicketService.registrarIngreso(code);

            await QRResultScreen(
              success: resp['estatus'] == true,
              message: resp['estatus'] == true
                  ? resp['mensaje']
                  : resp['error_msg'] ?? 'Error',
            ).launch(context);

            scanned = false;
          },
        ),
      ),
    );
  }
}
