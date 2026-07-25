import 'package:flutter/material.dart';

class BTLoading extends StatelessWidget {
  const BTLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
