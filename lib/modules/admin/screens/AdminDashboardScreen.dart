import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../shared/widgets/BTEmpty.dart';
import '../../../shared/widgets/BTLoading.dart';
import '../../../shared/widgets/BTScaffold.dart';
import '../widgets/AdminEventoCard.dart';

import '../models/AdminEventoModel.dart';
import '../models/AdminEventosResponseModel.dart';
import '../services/AdminEventoService.dart';
import 'package:bitsoftickets/modules/admin/screens/AdminBoletosScreen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool loading = true;

  List<AdminEventoModel> eventos = [];

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
      final AdminEventosResponseModel? response =
          await AdminEventoService.listarEventos();

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

          return AdminEventoCard(
            evento: evento,
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
