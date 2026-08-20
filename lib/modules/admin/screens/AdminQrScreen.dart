import 'dart:typed_data';

import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/BTScaffold.dart';
import 'package:share_plus/share_plus.dart';

class AdminQrScreen extends StatelessWidget {
  final Uint8List qrBytes;
  final String texto;
  final String folio;
  final String nombreAsistente;
  final String nombreEvento;
  final String? nombreArchivoSugerido;

  const AdminQrScreen({
    super.key,
    required this.qrBytes,
    required this.texto,
    required this.folio,
    required this.nombreAsistente,
    required this.nombreEvento,
    this.nombreArchivoSugerido,
  });

  String get mensajeCompartir {
    return texto.replaceAll('{folio}', folio).replaceAll(
          '{nombre_asistente}',
          nombreAsistente,
        );
  }

  String get nombreArchivo {
    final sugerido = _limpiarNombreSugerido(nombreArchivoSugerido);

    if (sugerido != null) {
      return sugerido;
    }

    final eventoSeguro = _normalizarParte(nombreEvento);
    final folioSeguro = folio.trim().replaceAll(
          RegExp(r'[^a-zA-Z0-9_-]'),
          '',
        );

    if (eventoSeguro.isNotEmpty && folioSeguro.isNotEmpty) {
      return '${eventoSeguro}_$folioSeguro.png';
    }

    if (eventoSeguro.isNotEmpty) {
      return '${eventoSeguro}_qr.png';
    }

    return folioSeguro.isEmpty ? 'boleto_qr.png' : 'boleto_$folioSeguro.png';
  }

  String _normalizarParte(String value) {
    const reemplazos = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'ü': 'u',
      'ñ': 'n',
    };

    var normalizado = value.trim().toLowerCase();

    reemplazos.forEach((origen, destino) {
      normalizado = normalizado.replaceAll(origen, destino);
    });

    return normalizado.replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  String? _limpiarNombreSugerido(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final segmentos = value.trim().split(RegExp(r'[\\/]'));
    var nombre = segmentos.last.replaceAll(
      RegExp(r'[^a-zA-Z0-9._-]'),
      '_',
    );

    if (nombre.isEmpty) {
      return null;
    }

    if (!nombre.toLowerCase().endsWith('.png')) {
      nombre = '$nombre.png';
    }

    return nombre;
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
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () => descargarQr(context),
                  icon: const Icon(Icons.download),
                  label: const Text("Descargar"),
                ),
                ElevatedButton.icon(
                  onPressed: () => compartirQr(context),
                  icon: const Icon(Icons.share),
                  label: const Text("Compartir"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> descargarQr(
    BuildContext context,
  ) async {
    try {
      await FlutterFileSaver().writeFileAsBytes(
        fileName: nombreArchivo,
        bytes: qrBytes,
      );

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Boleto descargado correctamente.',
          ),
        ),
      );
    } catch (e) {
      debugPrint(
        'ERROR DESCARGAR QR: $e',
      );

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No fue posible descargar el boleto.',
          ),
        ),
      );
    }
  }

  Future<void> compartirQr(
    BuildContext context,
  ) async {
    try {
      final renderBox = context.findRenderObject() as RenderBox?;

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
