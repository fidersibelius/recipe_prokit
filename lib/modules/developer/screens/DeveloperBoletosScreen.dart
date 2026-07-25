import 'package:bitsoftickets/modules/developer/screens/DeveloperBoletoDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../shared/widgets/BTScaffold.dart';
import '../models/EventoModel.dart';
import '../../../shared/widgets/BTEmpty.dart';
import '../../../shared/widgets/BTLoading.dart';

import '../models/BoletoModel.dart';
import '../models/BoletosResponseModel.dart';
import '../services/BoletoService.dart';
import 'package:bitsoftickets/modules/developer/screens/DeveloperQrScreen.dart';

class DeveloperBoletosScreen extends StatefulWidget {
  final EventoModel evento;

  const DeveloperBoletosScreen({
    super.key,
    required this.evento,
  });

  @override
  State<DeveloperBoletosScreen> createState() => _DeveloperBoletosScreenState();
}

class _DeveloperBoletosScreenState extends State<DeveloperBoletosScreen> {
  bool loading = true;

  List<BoletoModel> boletos = [];

  @override
  void initState() {
    super.initState();

    cargarBoletos();
  }

  Future<void> cargarBoletos() async {
    setState(() {
      loading = true;
    });

    try {
      final BoletosResponseModel? response = await BoletoService.listarBoletos(
        widget.evento.uid,
      );

      if (response != null && response.status) {
        boletos = response.boletos;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> mostrarCrearBoleto() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Nuevo boleto"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Nombre",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                print(controller.text);
                final ok = await BoletoService.crearBoleto(
                  widget.evento.uid,
                  controller.text,
                );

                Navigator.pop(context);

                final qr = await BoletoService.crearBoleto(
                  widget.evento.uid,
                  controller.text,
                );

                Navigator.pop(context);

                if (qr != null) {
                  await DeveloperQrScreen(
                    qrBytes: qr,
                  ).launch(context);

                  cargarBoletos();
                }
              },
              child: const Text("Crear"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BTScaffold(
      title: widget.evento.nombre,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mostrarCrearBoleto();
        },
        child: const Icon(Icons.add),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (boletos.isEmpty) {
      return const BTEmpty(
        titulo: "Sin boletos",
        mensaje: "Todavía no existen boletos registrados.",
      );
    }

    return ListView.separated(
      itemCount: boletos.length,
      separatorBuilder: (_, __) => const SizedBox.shrink(),
      itemBuilder: (context, index) {
        final boleto = boletos[index];

        return InkWell(
          onTap: () {
            DeveloperBoletoDetailScreen(
              boleto: boleto,
            ).launch(context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor:
                    boleto.checkIn == 1 ? Colors.green : Colors.orange,
                child: Icon(
                  boleto.checkIn == 1 ? Icons.verified : Icons.confirmation_num,
                  color: Colors.white,
                ),
              ),
              title: Text(
                boleto.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    "Registró: ${boleto.quienRegistro}",
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: boleto.checkIn == 1
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      boleto.checkIn == 1 ? "Usado" : "Disponible",
                      style: TextStyle(
                        color: boleto.checkIn == 1
                            ? Colors.green.shade800
                            : Colors.orange.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
