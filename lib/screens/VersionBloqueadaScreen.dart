import 'package:flutter/material.dart';
import 'package:recipe_prokit/components/RCFooterComponent.dart';

class VersionBloqueadaScreen extends StatelessWidget {
  const VersionBloqueadaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.system_update,
                        size: 100,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '¡Versión desactualizada!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Debes instalar la versión más reciente para poder ingresar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              const RCFooterComponent(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
