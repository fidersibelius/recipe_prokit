import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/AdminEventoModel.dart';

class AdminEventoCard extends StatelessWidget {
  final AdminEventoModel evento;
  final bool esDemo;
  final VoidCallback onTap;

  const AdminEventoCard({
    super.key,
    required this.evento,
    required this.esDemo,
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
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _imagenEvento(),
              14.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      evento.nombre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: boldTextStyle(
                        size: 20,
                      ),
                    ),
                    10.height,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (esDemo)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              'DEMO',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: activo
                                ? Colors.green.shade50
                                : Colors.red.shade50,
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
                                activo ? 'Activo' : 'Inactivo',
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
                    16.height,
                    Row(
                      children: [
                        const Icon(
                          Icons.confirmation_number_outlined,
                          size: 20,
                        ),
                        8.width,
                        Expanded(
                          child: Text(
                            '${evento.boletos} boletos',
                            style: primaryTextStyle(),
                          ),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 20,
                        ),
                        8.width,
                        Expanded(
                          child: Text(
                            '${evento.fechaIni} - ${evento.fechaFin}',
                            style: secondaryTextStyle(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagenEvento() {
    final url = evento.eventoImagen.trim();

    Widget placeholder() {
      return Image.asset(
        'images/no_image.png',
        width: 96,
        height: 120,
        fit: BoxFit.cover,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 96,
        height: 120,
        child: url.isEmpty
            ? placeholder()
            : Image.network(
                url,
                width: 96,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return placeholder();
                },
              ),
      ),
    );
  }
}
