import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../shared/widgets/BTScaffold.dart';

class DeveloperQrScreen extends StatelessWidget {
  final Uint8List qrBytes;

  const DeveloperQrScreen({
    super.key,
    required this.qrBytes,
  });

  @override
  Widget build(BuildContext context) {
    return BTScaffold(
      title: "Boleto creado",
      body: Center(
        child: Image.memory(
          qrBytes,
        ),
      ),
    );
  }
}
