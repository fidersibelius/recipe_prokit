import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BTError extends StatelessWidget {
  final String titulo;
  final String mensaje;
  final Future<void> Function() onRetry;

  const BTError({
    super.key,
    required this.titulo,
    required this.mensaje,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off,
                size: 64,
                color: Colors.red.shade400,
              ),
              16.height,
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: boldTextStyle(size: 18),
              ),
              8.height,
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: secondaryTextStyle(),
              ),
              20.height,
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
