import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../shared/widgets/BTScaffold.dart';
import '../models/BoletoModel.dart';
import '../services/BoletoService.dart';
import 'DeveloperQrScreen.dart';

class DeveloperBoletoDetailScreen extends StatefulWidget {
  final String eventoUid;
  final BoletoModel boleto;
  final String textoEvento;

  const DeveloperBoletoDetailScreen({
    super.key,
    required this.eventoUid,
    required this.boleto,
    required this.textoEvento,
  });

  @override
  State<DeveloperBoletoDetailScreen> createState() =>
      _DeveloperBoletoDetailScreenState();
}

class _DeveloperBoletoDetailScreenState
    extends State<DeveloperBoletoDetailScreen> {
  Future<void> reenviarQr() async {
    final qr = await BoletoService.obtenerQr(
      widget.eventoUid,
      widget.boleto.boletoUid,
    );

    if (!mounted) {
      return;
    }

    if (qr == null || qr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No fue posible obtener el QR.",
          ),
        ),
      );

      return;
    }

    await DeveloperQrScreen(
      qrBytes: qr,
      texto: widget.textoEvento,
      folio: widget.boleto.folio,
      nombreAsistente: widget.boleto.nombre,
    ).launch(context);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BTScaffold(
      title: "Detalle del boleto",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 40,
              child: Icon(
                Icons.confirmation_num,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.boleto.nombre,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text("Registró"),
                      subtitle: Text(widget.boleto.quienRegistro),
                    ),
                    ListTile(
                      leading: Icon(
                        widget.boleto.checkIn == 1
                            ? Icons.check_circle
                            : Icons.pending_actions,
                        color: widget.boleto.checkIn == 1
                            ? Colors.green
                            : Colors.orange,
                      ),
                      title: const Text("Estado"),
                      subtitle: Text(
                        widget.boleto.checkIn == 1 ? "Utilizado" : "Disponible",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: reenviarQr,
                icon: const Icon(Icons.qr_code),
                label: const Text("Reenviar QR"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
