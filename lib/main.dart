import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_prokit/screens/RCSplashScreen.dart';
import 'package:recipe_prokit/store/AppStore.dart';
import 'package:recipe_prokit/utils/AppTheme.dart';
import 'package:recipe_prokit/utils/RCConstants.dart';
import 'package:recipe_prokit/utils/RCDataGenerator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:recipe_prokit/screens/RCSignUpScreen.dart';
import 'utils/NavigationService.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:recipe_prokit/screens/AuthCheckScreen.dart';

AppStore appStore = AppStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize(aLocaleLanguageList: languageList());

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));

  defaultToastGravityGlobal = ToastGravity.BOTTOM;
  await dotenv.load(fileName: ".env");

  print("BASE_URL: ${dotenv.env['BASE_URL']}");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sneaker Shopping${!isMobile ? ' ${platformName()}' : ''}',
        home: const RCSplashScreen(),

        theme: !appStore.isDarkModeOn
            ? AppThemeData.lightTheme
            : AppThemeData.darkTheme,

        navigatorKey: globalNavigatorKey,
        scrollBehavior: SBehavior(),

        // YA EXISTIA
        supportedLocales: LanguageDataModel.languageLocales(),

        // AGREGA ESTO
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        localeResolutionCallback: (locale, supportedLocales) => locale,
      ),
    );
  }
}
