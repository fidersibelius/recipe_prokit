import 'package:flutter/material.dart';

import '../components/RCProfileComponent.dart';
import '../models/AccessCapabilities.dart';
import '../modules/admin/screens/AdminDashboardScreen.dart';
import '../modules/admin/screens/AdminUsersScreen.dart';
import '../modules/checker/screens/CheckerHomeScreen.dart';
import '../modules/checker/screens/CheckerScannerScreen.dart';

class AppDashboardScreen extends StatefulWidget {
  final AccessCapabilities capabilities;
  final String username;

  const AppDashboardScreen({
    super.key,
    required this.capabilities,
    required this.username,
  });

  @override
  State<AppDashboardScreen> createState() => _AppDashboardScreenState();
}

class _AppDashboardScreenState extends State<AppDashboardScreen> {
  int selectedIndex = 0;

  List<_AppDestination> get destinations {
    final capabilities = widget.capabilities;

    if (capabilities.esAdmin && capabilities.esChecker) {
      return [
        _AppDestination.page(
          label: 'Inicio',
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
          child: CheckerHomeScreen(name: widget.username),
        ),
        _AppDestination.page(
          label: 'Eventos',
          icon: Icons.calendar_month_outlined,
          selectedIcon: Icons.calendar_month,
          child: AdminDashboardScreen(
            esDemo: capabilities.esDemo,
          ),
        ),
        const _AppDestination.action(
          label: 'Escanear QR',
          icon: Icons.qr_code_scanner,
        ),
        const _AppDestination.page(
          label: 'Usuarios Admin',
          icon: Icons.group_outlined,
          selectedIcon: Icons.group,
          child: AdminUsersScreen(),
        ),
        const _AppDestination.page(
          label: 'Perfil',
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          child: RCProfileScreen(),
        ),
      ];
    }

    if (capabilities.esAdmin) {
      return [
        _AppDestination.page(
          label: 'Eventos',
          icon: Icons.calendar_month_outlined,
          selectedIcon: Icons.calendar_month,
          child: AdminDashboardScreen(
            esDemo: capabilities.esDemo,
          ),
        ),
        _AppDestination.page(
          label: 'Usuarios Admin',
          icon: Icons.group_outlined,
          selectedIcon: Icons.group,
          child: AdminUsersScreen(),
        ),
        _AppDestination.page(
          label: 'Perfil',
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          child: RCProfileScreen(),
        ),
      ];
    }

    return [
      _AppDestination.page(
        label: 'Inicio',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        child: CheckerHomeScreen(name: widget.username),
      ),
      const _AppDestination.action(
        label: 'Escanear QR',
        icon: Icons.qr_code_scanner,
      ),
      const _AppDestination.page(
        label: 'Perfil',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        child: RCProfileScreen(),
      ),
    ];
  }

  Future<void> _selectDestination(int index) async {
    final destination = destinations[index];

    if (destination.isScannerAction) {
      if (selectedIndex != 0) {
        setState(() {
          selectedIndex = 0;
        });
      }

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CheckerScannerScreen(),
        ),
      );
      return;
    }

    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentDestinations = destinations;

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: currentDestinations
            .map(
              (destination) => destination.child ?? const SizedBox.shrink(),
            )
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: _selectDestination,
        items: currentDestinations
            .map(
              (destination) => BottomNavigationBarItem(
                icon: Icon(destination.icon),
                activeIcon: Icon(
                  destination.selectedIcon ?? destination.icon,
                ),
                label: destination.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _AppDestination {
  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final Widget? child;
  final bool isScannerAction;

  const _AppDestination.page({
    required this.label,
    required this.icon,
    required this.child,
    this.selectedIcon,
  }) : isScannerAction = false;

  const _AppDestination.action({
    required this.label,
    required this.icon,
  })  : selectedIcon = null,
        child = null,
        isScannerAction = true;
}
