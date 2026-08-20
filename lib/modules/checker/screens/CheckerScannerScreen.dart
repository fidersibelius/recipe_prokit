import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nb_utils/nb_utils.dart';

import '../services/CheckerTicketService.dart';
import 'CheckerResultScreen.dart';

class CheckerScannerScreen extends StatefulWidget {
  const CheckerScannerScreen({super.key});

  @override
  State<CheckerScannerScreen> createState() => _CheckerScannerScreenState();
}

class _CheckerScannerScreenState extends State<CheckerScannerScreen> {
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
          centerTitle: true,
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

            try {
              final resp = await CheckerTicketService.registrarIngreso(code);

              if (!mounted) {
                return;
              }

              await CheckerResultScreen(
                success: resp['status'] == true,
                message: resp['status'] == true
                    ? resp['mensaje'] ?? 'Ingreso registrado correctamente.'
                    : resp['error_msg'] ??
                        resp['message'] ??
                        'No fue posible registrar el ingreso.',
              ).launch(context);
            } catch (e) {
              debugPrint(
                'ERROR REGISTRAR INGRESO: $e',
              );

              if (!mounted) {
                return;
              }

              final mensaje = e.toString().replaceFirst(
                    'Exception: ',
                    '',
                  );

              await CheckerResultScreen(
                success: false,
                title: 'NO FUE POSIBLE VALIDAR',
                message: mensaje,
              ).launch(context);
            } finally {
              scanned = false;
            }
          },
        ),
      ),
    );
  }
}
