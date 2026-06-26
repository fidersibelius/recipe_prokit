import 'package:flutter/material.dart';
import 'package:recipe_prokit/screens/RCSignUpScreen.dart';
import 'package:recipe_prokit/screens/RcDashBoardScreen.dart';
import 'package:recipe_prokit/screens/VersionBloqueadaScreen.dart';
import 'package:recipe_prokit/services/AuthStorage.dart';
import 'package:recipe_prokit/services/VersionService.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final token = await AuthStorage.getToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      final version = await VersionService.cargaInicial();

      if (version['estatus'] != true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const VersionBloqueadaScreen(),
          ),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RcDashBoardScreen(
            name: 'Usuario',
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RCSignUpScreen(selectedIndex: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
