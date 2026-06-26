import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_prokit/components/RCFooterComponent.dart';
import 'package:recipe_prokit/screens/RCWelcomeScreen.dart';
//import 'package:recipe_prokit/utils/RCColors.dart';
import 'package:recipe_prokit/screens/AuthCheckScreen.dart';

class RCSplashScreen extends StatefulWidget {
  const RCSplashScreen({Key? key}) : super(key: key);

  @override
  _RCSplashScreenState createState() => _RCSplashScreenState();
}

class _RCSplashScreenState extends State<RCSplashScreen> {
  @override
  void initState() {
    super.initState();

    print("🔥🔥🔥 SPLASH EJECUTANDOSE 🔥🔥🔥");

    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);

    await 3.seconds.delay;

    finish(context);

    const AuthCheckScreen().launch(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  'images/bitsoftickets.png',
                  width: 350,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const RCFooterComponent(),
                  24.height,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
