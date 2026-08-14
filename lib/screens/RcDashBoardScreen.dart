import 'package:bitsoftickets/modules/admin/screens/AdminDashboardScreen.dart';
import 'package:bitsoftickets/services/AuthStorage.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bitsoftickets/components/RCHomeComponent.dart';
import 'package:bitsoftickets/components/RCProfileComponent.dart';
//import 'package:bitsoftickets/components/RCSearchComponent.dart';
import 'package:bitsoftickets/main.dart';
import 'package:bitsoftickets/utils/RCColors.dart';
import 'package:bitsoftickets/screens/QRScannerScreen.dart';

class RcDashBoardScreen extends StatefulWidget {
  final String name;

  const RcDashBoardScreen({
    super.key,
    required this.name,
  });

  //RcDashBoardScreen({required this.name});

  @override
  _RcDashBoardScreenState createState() => _RcDashBoardScreenState();
}

class _RcDashBoardScreenState extends State<RcDashBoardScreen> {
  int selectedIndex = 0;
  int role = 0;
  //final role = await AuthStorage.getRole();
  @override
  void initState() {
    super.initState();
    cargarRol();
  }

  Future<void> cargarRol() async {
    final roleGuardado = await AuthStorage.getRole();

    if (!mounted) {
      return;
    }

    setState(() {
      role = roleGuardado;

      if (role == 1 && selectedIndex == 1) {
        selectedIndex = 0;
      }
    });
  }

  Widget getTabs() {
    if (selectedIndex == 0) {
      if (role == 1) {
        return const AdminDashboardScreen();
      }

      return RCHomeComponent(
        name: widget.name,
      );
    }

    if (selectedIndex == 2) {
      return RCProfileScreen();
    }

    return RCHomeComponent(
      name: widget.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkModeOn ? Colors.black : Colors.white,
      body: getTabs(),
      floatingActionButton: Material(
        elevation: 5,
        borderRadius: radius(24),
        child: Container(
          width: context.width() - 32,
          decoration: boxDecorationDefault(
              borderRadius: radius(24), color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              selectedIndex == 0
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Inicio',
                            style: boldTextStyle(color: primaryColor)),
                        4.height,
                        Icon(Icons.circle, size: 10, color: primaryColor),
                      ],
                    )
                  : IconButton(
                      onPressed: () {
                        selectedIndex = 0;
                        setState(() {});
                      },
                      icon: Icon(LineIcons.home,
                          color: rcSecondaryTextColor, size: 30),
                    ),
              if (role != 1)
                selectedIndex == 1
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Escanear',
                            style: boldTextStyle(
                              color: primaryColor,
                            ),
                          ),
                          4.height,
                          Icon(
                            Icons.circle,
                            size: 10,
                            color: primaryColor,
                          ),
                        ],
                      )
                    : IconButton(
                        onPressed: () async {
                          final result =
                              await QRScannerScreen().launch(context);

                          if (result == true && mounted) {
                            setState(() {
                              selectedIndex = 0;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.qr_code_scanner,
                          color: rcSecondaryTextColor,
                          size: 30,
                        ),
                      ),
              selectedIndex == 2
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Perfil',
                            style: boldTextStyle(color: primaryColor)),
                        4.height,
                        Icon(Icons.circle, size: 10, color: primaryColor),
                      ],
                    )
                  : IconButton(
                      onPressed: () {
                        selectedIndex = 2;
                        setState(() {});
                      },
                      icon: Icon(LineIcons.user,
                          color: rcSecondaryTextColor, size: 30),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
