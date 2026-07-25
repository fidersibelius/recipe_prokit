import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BTEmpty extends StatelessWidget {
  final String titulo;
  final String mensaje;
  final IconData icono;

  const BTEmpty({
    super.key,
    required this.titulo,
    required this.mensaje,
    this.icono = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icono,
              size: 70,
              color: Colors.grey,
            ),
            20.height,
            Text(
              titulo,
              style: boldTextStyle(size: 22),
              textAlign: TextAlign.center,
            ),
            10.height,
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: secondaryTextStyle(size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
