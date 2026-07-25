import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../shared/widgets/BTEmpty.dart';
import '../../../shared/widgets/BTLoading.dart';
import '../../../shared/widgets/BTScaffold.dart';
import '../../../shared/widgets/EventoCard.dart';

import '../models/EventoModel.dart';
import '../models/EventosResponseModel.dart';
import '../services/EventoService.dart';
import 'package:bitsoftickets/modules/developer/screens/DeveloperBoletosScreen.dart';

class DeveloperDashboardScreen extends StatefulWidget {
  const DeveloperDashboardScreen({super.key});

  @override
  State<DeveloperDashboardScreen> createState() =>
      _DeveloperDashboardScreenState();
}

class _DeveloperDashboardScreenState extends State<DeveloperDashboardScreen> {
  bool loading = true;

  List<EventoModel> eventos = [];

  @override
  void initState() {
    super.initState();
    cargarEventos();
  }

  Future<void> cargarEventos() async {
    setState(() {
      loading = true;
    });

    try {
      final EventosResponseModel? response =
          await EventoService.listarEventos();

      if (response != null && response.status) {
        eventos = response.eventos;
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

          return EventoCard(
            evento: evento,
            onTap: () {
              DeveloperBoletosScreen(
                evento: evento,
              ).launch(context);
            },
          );
        },
      ),
    );
  }
}
