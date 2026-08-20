import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../shared/widgets/BTEmpty.dart';
import '../../../shared/widgets/BTError.dart';
import '../../../shared/widgets/BTLoading.dart';
import '../../../shared/widgets/BTScaffold.dart';
import '../widgets/AdminEventoCard.dart';

import '../models/AdminEventoModel.dart';
import '../models/AdminEventosResponseModel.dart';
import '../services/AdminEventoService.dart';
import 'package:bitsoftickets/modules/admin/screens/AdminBoletosScreen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final bool esDemo;

  const AdminDashboardScreen({
    super.key,
    required this.esDemo,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool loading = true;
  String? errorCarga;

  List<AdminEventoModel> eventos = [];

  @override
  void initState() {
    super.initState();
    cargarEventos();
  }

  Future<void> cargarEventos() async {
    setState(() {
      loading = true;
      errorCarga = null;
    });

    try {
      final AdminEventosResponseModel? response =
          await AdminEventoService.listarEventos();

      if (response != null && response.status) {
        eventos = response.eventos;
      } else {
        errorCarga = 'No fue posible obtener la lista de eventos.';
      }
    } catch (e) {
      debugPrint('ERROR CARGAR EVENTOS: $e');
      errorCarga = 'No fue posible comunicarse con el servidor.';
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BTScaffold(
      title: "Eventos",
      showBack: false,
      body: _body(),
    );
  }

  Widget _body() {
    if (loading) {
      return const BTLoading();
    }

    if (errorCarga != null) {
      return BTError(
        titulo: 'No fue posible cargar los eventos',
        mensaje: errorCarga!,
        onRetry: cargarEventos,
      );
    }

    if (eventos.isEmpty) {
      return const BTEmpty(
        titulo: "Sin eventos",
        mensaje: "Todavía no existen eventos registrados.",
      );
    }

    return RefreshIndicator(
      onRefresh: cargarEventos,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: eventos.length,
        itemBuilder: (context, index) {
          final evento = eventos[index];

          return AdminEventoCard(
            evento: evento,
            esDemo: widget.esDemo,
            onTap: () {
              AdminBoletosScreen(
                evento: evento,
              ).launch(context);
            },
          );
        },
      ),
    );
  }
}
