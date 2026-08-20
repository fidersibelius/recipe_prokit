import 'package:flutter/material.dart';

import '../models/AccessCapabilities.dart';
import '../services/AuthStorage.dart';
import '../shared/screens/NoPermissionsScreen.dart';
import 'AppDashboardScreen.dart';

class AccessGatewayScreen extends StatefulWidget {
  final String? username;

  const AccessGatewayScreen({
    super.key,
    this.username,
  });

  @override
  State<AccessGatewayScreen> createState() => _AccessGatewayScreenState();
}

class _AccessGatewayScreenState extends State<AccessGatewayScreen> {
  late final Future<_AccessState> _accessFuture;

  @override
  void initState() {
    super.initState();
    _accessFuture = _loadAccess();
  }

  Future<_AccessState> _loadAccess() async {
    final capabilities = await AuthStorage.getCapabilities();
    final storedUsername = await AuthStorage.getUser();

    return _AccessState(
      capabilities: capabilities,
      username: widget.username ?? storedUsername ?? 'Usuario',
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_AccessState>(
      future: _accessFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const NoPermissionsScreen();
        }

        final state = snapshot.data!;

        if (!state.capabilities.hasAccess) {
          return const NoPermissionsScreen();
        }

        return AppDashboardScreen(
          capabilities: state.capabilities,
          username: state.username,
        );
      },
    );
  }
}

class _AccessState {
  final AccessCapabilities capabilities;
  final String username;

  const _AccessState({
    required this.capabilities,
    required this.username,
  });
}
