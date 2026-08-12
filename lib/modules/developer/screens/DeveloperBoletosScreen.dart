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
import '../widgets/DeveloperBoletosGrid.dart';

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
  List<BoletoModel> boletosFiltrados = [];

  final TextEditingController buscarController = TextEditingController();

  int registrosPorPagina = 15;

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
      print("RESPONSE BOLETOS: $response");

      if (response != null && response.status) {
        print("TOTAL BOLETOS: ${response.boletos.length}");
      }

      if (response != null && response.status) {
        boletos = response.boletos;

        boletosFiltrados = List.from(
          boletos,
        );

        print("SCREEN BOLETOS: ${boletos.length}");
        print("SCREEN FILTRADOS: ${boletosFiltrados.length}");
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
    String nombre = '';

    final nombreConfirmado = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Nuevo boleto"),
          content: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            onChanged: (texto) {
              nombre = texto;
            },
            onSubmitted: (texto) {
              final valor = texto.trim();

              if (valor.isNotEmpty) {
                Navigator.pop(
                  dialogContext,
                  valor,
                );
              }
            },
            decoration: const InputDecoration(
              labelText: "Nombre",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                final valor = nombre.trim();

                if (valor.isEmpty) {
                  return;
                }

                Navigator.pop(
                  dialogContext,
                  valor,
                );
              },
              child: const Text("Crear"),
            ),
          ],
        );
      },
    );

    if (nombreConfirmado == null || nombreConfirmado.isEmpty || !mounted) {
      return;
    }

    final qr = await BoletoService.crearBoleto(
      widget.evento.uid,
      nombreConfirmado,
    );

    if (!mounted) {
      return;
    }

    if (qr == null || qr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "El boleto se creó, pero no fue posible obtener el QR.",
          ),
        ),
      );

      await cargarBoletos();
      return;
    }

    await DeveloperQrScreen(
      qrBytes: qr,
      texto: widget.evento.texto,
      folio: '',
      nombreAsistente: nombreConfirmado,
    ).launch(context);

    if (mounted) {
      await cargarBoletos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BTScaffold(
      title: widget.evento.nombre,
      actions: [
        IconButton(
          onPressed: mostrarCrearBoleto,
          icon: const Icon(Icons.add),
        ),
      ],
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: buscarController,
            onChanged: (texto) {
              setState(() {
                boletosFiltrados = boletos.where((boleto) {
                  return boleto.nombre.toLowerCase().contains(
                        texto.toLowerCase(),
                      );
                }).toList();
              });
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Buscar boleto...",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: DeveloperBoletosGrid(
            boletos: boletosFiltrados,
            onDetalle: (boleto) {
              DeveloperBoletoDetailScreen(
                eventoUid: widget.evento.uid,
                boleto: boleto,
                textoEvento: widget.evento.texto,
              ).launch(context);
            },
          ),
        ),
      ],
    ); /*Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: boletosPagina.length,
            separatorBuilder: (_, __) => const SizedBox.shrink(),
            itemBuilder: (context, index) {
              final boleto = boletosPagina[index];

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
                        boleto.checkIn == 1
                            ? Icons.verified
                            : Icons.confirmation_num,
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
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: paginaActual > 1
                    ? () {
                        paginaActual--;

                        actualizarPagina();
                      }
                    : null,
                child: const Text("Anterior"),
              ),
              Text(
                "Página $paginaActual de $totalPaginas",
              ),
              ElevatedButton(
                onPressed: paginaActual * registrosPorPagina < boletos.length
                    ? () {
                        paginaActual++;

                        actualizarPagina();
                      }
                    : null,
                child: const Text("Siguiente"),
              ),
            ],
          ),
        ),
      ],
    );*/
  }
}
