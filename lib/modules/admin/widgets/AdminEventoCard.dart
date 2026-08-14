import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/AdminEventoModel.dart';

class AdminEventoCard extends StatelessWidget {
  final AdminEventoModel evento;
  final VoidCallback onTap;

  const AdminEventoCard({
    super.key,
    required this.evento,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool activo = evento.isActive == 1;

    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ============================
              /// TITULO
              /// ============================
              Row(
                children: [
                  Expanded(
                    child: Text(
                      evento.nombre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: boldTextStyle(
                        size: 22,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: activo ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: activo ? Colors.green : Colors.red,
                        ),
                        6.width,
                        Text(
                          activo ? "Activo" : "Inactivo",
                          style: TextStyle(
                            color: activo ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              20.height,

              /// ============================
              /// BOLETOS
              /// ============================

              Row(
                children: [
                  const Icon(
                    Icons.confirmation_number_outlined,
                  ),
                  10.width,
                  Text(
                    "${evento.boletos} boletos",
                    style: primaryTextStyle(),
                  ),
                ],
              ),

              12.height,

              /// ============================
              /// FECHAS
              /// ============================

              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                  ),
                  10.width,
                  Expanded(
                    child: Text(
                      "${evento.fechaIni}  -  ${evento.fechaFin}",
                      style: secondaryTextStyle(),
                    ),
                  ),
                ],
              ),

              20.height,

              const Divider(),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  label: const Text("Abrir"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
