import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class QRResultScreen extends StatelessWidget {
  final bool success;
  final String message;

  const QRResultScreen({
    super.key,
    required this.success,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: success ? Colors.green : Colors.red,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.cancel,
                  size: 160,
                  color: Colors.white,
                ),
                30.height,
                Text(
                  success ? 'ACCESO AUTORIZADO' : 'TICKET YA UTILIZADO',
                  textAlign: TextAlign.center,
                  style: boldTextStyle(
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                20.height,
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: primaryTextStyle(
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                40.height,
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('ESCANEAR OTRO'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
