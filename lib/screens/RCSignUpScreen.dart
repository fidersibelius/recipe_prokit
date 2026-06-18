import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_prokit/components/RCSignInComponent.dart';
import 'package:recipe_prokit/components/RCSignUpComponent.dart';
import 'package:recipe_prokit/main.dart';
import 'package:recipe_prokit/utils/RCColors.dart';
import 'package:recipe_prokit/utils/RCCommon.dart';

class RCSignUpScreen extends StatefulWidget {
  int selectedIndex;

  RCSignUpScreen({required this.selectedIndex});

  @override
  State<RCSignUpScreen> createState() => _RCSignUpScreenState();
}

class _RCSignUpScreenState extends State<RCSignUpScreen> {
  @override
  void initState() {
    super.initState();
    setStatusBarColor(appStore.isDarkModeOn ? Colors.black : Colors.white);
  }

  var form_key = GlobalKey<FormState>();

  FocusNode name = FocusNode();
  FocusNode password = FocusNode();
  TextEditingController emailController = TextEditingController();

  Widget getComponent() {
    if (widget.selectedIndex == 0) {
      return RCSignUpComponent();
    } else {
      return RCSignInComponent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appStore.isDarkModeOn ? Colors.black : Colors.white,
        body: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Form(
                key: form_key,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getComponent(),
                  ],
                ).paddingAll(16),
              ),
            ),
          ],
        ));
  }
}
