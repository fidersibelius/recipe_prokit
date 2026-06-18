import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_prokit/screens/RcDashBoardScreen.dart';
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
          Text('Welcome to,',
              style: boldTextStyle(
                  size: 30,
                  fontFamily: GoogleFonts.playfairDisplay().fontFamily)),
          12.height,
          Image.asset(
            'images/recipe_app_logo.png',
            height: 120,
          ),
          24.height,
          AppTextField(
            controller: nameController,
            nextFocus: password,
            textFieldType: TextFieldType.NAME,
            textStyle: boldTextStyle(),
            decoration: InputDecoration(
              prefixIcon:
                  Icon(Icons.person_outlined, color: rcSecondaryTextColor),
              hintText: 'Enter username',
              hintStyle: secondaryTextStyle(),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: rcSecondaryTextColor)),
            ),
          ),
          16.height,
          AppTextField(
            controller: passwordController,
            focus: password,
            textFieldType: TextFieldType.PASSWORD,
            suffixIconColor: rcSecondaryTextColor,
            textStyle: boldTextStyle(),
            decoration: InputDecoration(
              prefixIcon:
                  Icon(Icons.lock_outlined, color: rcSecondaryTextColor),
              hintText: 'Enter password',
              hintStyle: secondaryTextStyle(),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: rcSecondaryTextColor)),
            ),
          ),
          150.height,
          Container(
                  child: Text('Sign In',
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
                RcDashBoardScreen(
                  name: nameController.text,
                ).launch(context);
              } else {
                toast('Usuario o contraseña incorrectos');
              }
            }
          },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent),
        ]));
  }
}
