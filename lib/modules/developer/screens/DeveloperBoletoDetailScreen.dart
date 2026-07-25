import 'package:flutter/material.dart';

import '../../../shared/widgets/BTScaffold.dart';
import '../models/BoletoModel.dart';

class DeveloperBoletoDetailScreen extends StatelessWidget {
  final BoletoModel boleto;

  const DeveloperBoletoDetailScreen({
    super.key,
    required this.boleto,
  });

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
              boleto.nombre,
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
                      subtitle: Text(boleto.quienRegistro),
                    ),
                    ListTile(
                      leading: Icon(
                        boleto.checkIn == 1
                            ? Icons.check_circle
                            : Icons.pending_actions,
                        color:
                            boleto.checkIn == 1 ? Colors.green : Colors.orange,
                      ),
                      title: const Text("Estado"),
                      subtitle: Text(
                        boleto.checkIn == 1 ? "Utilizado" : "Disponible",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
