import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../shared/widgets/BTScaffold.dart';
import '../models/EventoModel.dart';

class DeveloperEventoScreen extends StatelessWidget {
  final EventoModel evento;

  const DeveloperEventoScreen({
    super.key,
    required this.evento,
  });

  @override
  Widget build(BuildContext context) {
    final bool activo = evento.isActive == 1;

    return BTScaffold(
      title: evento.nombre,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ///=================================
            /// Imagen Evento
            ///=================================

            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                evento.eventoImagen,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    height: 220,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 60,
                      ),
                    ),
                  );
                },
              ),
            ),

            24.height,

            Text(
              evento.nombre,
              style: boldTextStyle(
                size: 28,
              ),
            ),

            16.height,

            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: activo ? Colors.green : Colors.red,
                ),
                8.width,
                Text(
                  activo ? "Activo" : "Inactivo",
                  style: boldTextStyle(
                    color: activo ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),

            20.height,

            Row(
              children: [
                const Icon(Icons.calendar_month_outlined),
                10.width,
                Expanded(
                  child: Text(
                    "${evento.fechaIni} - ${evento.fechaFin}",
                    style: primaryTextStyle(),
                  ),
                ),
              ],
            ),

            12.height,

            Row(
              children: [
                const Icon(Icons.confirmation_number_outlined),
                10.width,
                Expanded(
                  child: Text(
                    "${evento.boletos} boletos registrados",
                    style: primaryTextStyle(),
                  ),
                ),
              ],
            ),

            40.height,

            ElevatedButton.icon(
              onPressed: () {
                // TODO
                // Abrir lista de boletos
              },
              icon: const Icon(Icons.list_alt),
              label: const Text("Ver boletos"),
            ),

            16.height,

            ElevatedButton.icon(
              onPressed: () {
                // TODO
                // Crear boleto
              },
              icon: const Icon(Icons.person_add_alt),
              label: const Text("Crear boleto"),
            ),

            16.height,

            ElevatedButton.icon(
              onPressed: () {
                // TODO
                // Generar QR
              },
              icon: const Icon(Icons.qr_code_2),
              label: const Text("Generar QR"),
            ),
          ],
        ),
      ),
    );
  }
}
