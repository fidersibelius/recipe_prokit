import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_prokit/components/RCFooterComponent.dart';
import 'package:recipe_prokit/screens/RcDashBoardScreen.dart';
import 'package:recipe_prokit/screens/VersionBloqueadaScreen.dart';
import 'package:recipe_prokit/services/AuthStorage.dart';
import 'package:recipe_prokit/services/VersionService.dart';
import 'package:recipe_prokit/utils/RCColors.dart';
import 'package:recipe_prokit/services/AuthService.dart';

class RCSignInComponent extends StatelessWidget {
  FocusNode password = FocusNode();
  TextEditingController passwordController = TextEditingController();

  var form_key = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: form_key,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          (context.statusBarHeight + 40).toInt().height,
          Text('Bienvenido a',
              style: boldTextStyle(
                  size: 30,
                  fontFamily: GoogleFonts.playfairDisplay().fontFamily)),
          12.height,
          Image.asset(
            'images/bitsoftickets.png',
            height: 120,
          ),
          16.height,
          Text(
            'Ingresa tus credenciales a continuación:',
            textAlign: TextAlign.center,
            style: secondaryTextStyle(
              size: 16,
            ),
          ),
          24.height,
          24.height,
          TextFormField(
            controller: nameController,
            style: boldTextStyle(),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person_outlined,
                color: rcSecondaryTextColor,
              ),
              hintText: 'Usuario',
              hintStyle: secondaryTextStyle(),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: rcSecondaryTextColor,
                ),
              ),
            ),
          ),
          16.height,
          TextFormField(
            controller: passwordController,
            obscureText: true,
            style: boldTextStyle(),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock_outlined,
                color: rcSecondaryTextColor,
              ),
              hintText: 'Contraseña',
              hintStyle: secondaryTextStyle(),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: rcSecondaryTextColor,
                ),
              ),
            ),
          ),
          150.height,
          Container(
                  child: Text('Iniciar Sesión',
                          style: boldTextStyle(size: 18, color: Colors.white))
                      .center(),
                  width: context.width() - 40,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: radius(32), color: primaryColor))
              .onTap(() async {
            if (true) {
              print("huerco pro");
              final ok = await AuthService.login(
                nameController.text,
                passwordController.text,
              );

              if (ok) {
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

                await AuthStorage.saveUser(
                  nameController.text,
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RcDashBoardScreen(
                      name: nameController.text,
                    ),
                  ),
                );
              } else {
                toast('Usuario o contraseña incorrectos');
              }
            }
          },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent),
          SizedBox(height: 80),
          const RCFooterComponent(),
          24.height,
        ]));
  }
}
