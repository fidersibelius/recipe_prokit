import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_prokit/screens/QRScannerScreen.dart';

class RCHomeComponent extends StatefulWidget {
  String name;

  RCHomeComponent({required this.name});

  @override
  State<RCHomeComponent> createState() => _RCHomeComponentState();
}

class _RCHomeComponentState extends State<RCHomeComponent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (context.statusBarHeight + 16).toInt().height,
          /*  Text(
            'Bienvenido,',
            style: boldTextStyle(
              size: 30,
              fontFamily: GoogleFonts.playfairDisplay().fontFamily,
            ),
          ).paddingSymmetric(horizontal: 16),
          Text(
            widget.name,
            style: boldTextStyle(
              size: 30,
              fontFamily: GoogleFonts.playfairDisplay().fontFamily,
            ),
          ).paddingSymmetric(horizontal: 16),*/
          24.height,
          Center(
            child: Image.asset(
              'images/recipe_app_logo.png',
              height: 180,
            ),
          ),
          32.height,
          Container(
            width: context.width(),
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 60,
                ),
                12.height,
                Text(
                  'Escanear QR',
                  style: boldTextStyle(
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ).onTap(() async {
            QRScannerScreen().launch(context);

            // prueba temporal
            /*final resp = await TicketService.registrarIngreso(
              '58d2907a|39c2|4bf7|ac5d|4423a6dd9ece||bd9b1bf0|c08e|498d|99d4|3f5ed09ca388',
            );

            print(resp);*/
          },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent),
          20.height,
          /*Container(
            width: context.width(),
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.verified_user,
                  color: Colors.white,
                  size: 60,
                ),
                12.height,
                Text(
                  'Verificar Ticket',
                  style: boldTextStyle(
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),*/
          80.height,
        ],
      ),
    );
  }
}
