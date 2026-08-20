import 'package:flutter/material.dart';

import '../../../shared/widgets/BTScaffold.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BTScaffold(
      title: 'Usuarios Admin',
      showBack: false,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.group_outlined,
              size: 72,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Administración de usuarios',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Disponible próximamente.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
