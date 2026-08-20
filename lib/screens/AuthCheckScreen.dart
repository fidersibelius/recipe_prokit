import 'package:flutter/material.dart';
import 'package:bitsoftickets/screens/RCSignUpScreen.dart';
import 'package:bitsoftickets/navigation/AccessGatewayScreen.dart';
import 'package:bitsoftickets/screens/VersionBloqueadaScreen.dart';
import 'package:bitsoftickets/services/AuthStorage.dart';
import 'package:bitsoftickets/services/VersionService.dart';

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

      if (version['status'] != true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const VersionBloqueadaScreen(),
          ),
        );
        return;
      }

      final username = await AuthStorage.getUser();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AccessGatewayScreen(
            username: username,
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
