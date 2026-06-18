import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_prokit/main.dart';
import 'package:recipe_prokit/utils/RCColors.dart';
import 'package:recipe_prokit/services/AuthStorage.dart';
import 'package:recipe_prokit/screens/RCSignUpScreen.dart';

class RCProfileScreen extends StatefulWidget {
  @override
  State<RCProfileScreen> createState() => _RCProfileScreenState();
}

class _RCProfileScreenState extends State<RCProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkModeOn ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              30.height,
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('images/usuario_avatar.png'),
              ),
              20.height,
              Text(
                'Usuario',
                style: boldTextStyle(size: 24),
              ),
              40.height,
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text('Modo oscuro'),
                trailing: Switch(
                  value: appStore.isDarkModeOn,
                  activeThumbColor: appColorPrimary,
                  onChanged: (s) {
                    appStore.toggleDarkMode(value: s);
                    setState(() {});
                  },
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  await AuthStorage.clear();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RCSignUpScreen(selectedIndex: 1),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
