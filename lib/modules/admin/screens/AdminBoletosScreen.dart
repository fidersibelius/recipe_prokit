import 'package:bitsoftickets/modules/admin/screens/AdminBoletoDetailScreen.dart';
import 'package:bitsoftickets/modules/admin/screens/AdminBoletoErrorScreen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../shared/widgets/BTScaffold.dart';
import '../../../shared/widgets/BTError.dart';
import '../models/AdminEventoModel.dart';
import '../../../shared/widgets/BTEmpty.dart';

import '../models/AdminBoletoModel.dart';
import '../models/AdminBoletosResponseModel.dart';
import '../services/AdminBoletoService.dart';
import 'package:bitsoftickets/modules/admin/screens/AdminQrScreen.dart';
import '../widgets/AdminBoletosGrid.dart';

class AdminBoletosScreen extends StatefulWidget {
  final AdminEventoModel evento;

  const AdminBoletosScreen({
    super.key,
    required this.evento,
  });

  @override
  State<AdminBoletosScreen> createState() => _AdminBoletosScreenState();
}

class _AdminBoletosScreenState extends State<AdminBoletosScreen> {
  bool loading = true;
  bool creandoBoleto = false;
  String? errorCarga;

  List<AdminBoletoModel> boletos = [];
  List<AdminBoletoModel> boletosFiltrados = [];

  final TextEditingController buscarController = TextEditingController();

  int registrosPorPagina = 15;

  @override
  void initState() {
    super.initState();

    cargarBoletos();
  }

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  Future<void> cargarBoletos() async {
    setState(() {
      loading = true;
      errorCarga = null;
    });

    try {
      final AdminBoletosResponseModel? response =
          await AdminBoletoService.listarBoletos(
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
      } else {
        errorCarga = 'No fue posible obtener la lista de boletos.';
      }
    } catch (e) {
      debugPrint('ERROR CARGAR BOLETOS: $e');
      errorCarga = 'No fue posible comunicarse con el servidor.';
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> mostrarCrearBoleto() async {
    if (creandoBoleto) {
      return;
    }

    setState(() {
      creandoBoleto = true;
    });
    try {
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

      final resultado = await AdminBoletoService.crearBoleto(
        widget.evento.uid,
        nombreConfirmado,
      );

      if (!mounted) {
        return;
      }

      if (!resultado.success) {
        await AdminBoletoErrorScreen(
          message: resultado.errorMessage ?? 'No fue posible crear el boleto.',
        ).launch(context);
        return;
      }

      await AdminQrScreen(
        qrBytes: resultado.qrBytes!,
        texto: widget.evento.texto,
        folio: '',
        nombreAsistente: nombreConfirmado,
        nombreEvento: widget.evento.nombre,
        nombreArchivoSugerido: resultado.fileName,
      ).launch(context);

      if (mounted) {
        await cargarBoletos();
      }
    } finally {
      if (mounted) {
        setState(() {
          creandoBoleto = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BTScaffold(
      title: widget.evento.nombre,
      actions: [
        IconButton(
          tooltip: creandoBoleto ? 'Creando boleto...' : 'Crear boleto',
          onPressed: creandoBoleto ? null : mostrarCrearBoleto,
          icon: creandoBoleto
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.add),
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

    if (errorCarga != null) {
      return BTError(
        titulo: 'No fue posible cargar los boletos',
        mensaje: errorCarga!,
        onRetry: cargarBoletos,
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
              final busqueda = texto.trim().toLowerCase();

              setState(() {
                boletosFiltrados = boletos.where((boleto) {
                  return boleto.nombre.toLowerCase().contains(busqueda) ||
                      boleto.folio.toLowerCase().contains(busqueda) ||
                      boleto.quienRegistro.toLowerCase().contains(busqueda);
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
          child: AdminBoletosGrid(
            boletos: boletosFiltrados,
            onDetalle: (boleto) {
              AdminBoletoDetailScreen(
                eventoUid: widget.evento.uid,
                eventoNombre: widget.evento.nombre,
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
                  AdminBoletoDetailScreen(
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
