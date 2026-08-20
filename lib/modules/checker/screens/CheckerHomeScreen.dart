import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bitsoftickets/services/AuthStorage.dart';

import 'CheckerScannerScreen.dart';

class CheckerHomeScreen extends StatefulWidget {
  final String name;

  const CheckerHomeScreen({
    super.key,
    required this.name,
  });

  @override
  State<CheckerHomeScreen> createState() => _CheckerHomeScreenState();
}

class _CheckerHomeScreenState extends State<CheckerHomeScreen> {
  String logoBitsof = "";
  String logoOrg = "";

  String evento = "";
  String eventoImagen = "";

  @override
  void initState() {
    super.initState();
    cargarEvento();
  }

  Future<void> cargarEvento() async {
    logoBitsof = await AuthStorage.getLogoBitsof() ?? "";
    logoOrg = await AuthStorage.getLogoOrg() ?? "";

    evento = await AuthStorage.getEvento() ?? "";
    eventoImagen = await AuthStorage.getEventoImagen() ?? "";

    print("LOGOB: $logoBitsof");
    print("LOGOO: $logoOrg");
    print("EVENTO: $evento");
    print("IMAGEN: $eventoImagen");

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          (context.statusBarHeight + 8).toInt().height,

          // Banner del evento
          if (eventoImagen.isNotEmpty)
            Row(
              children: [
                Image.network(
                  logoBitsof,
                  height: 64,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.08),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.06),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.network(
                      logoOrg,
                      height: 64,
                    ),
                  ),
                ),
              ],
            ),
          24.height,
          Align(
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "EVENTO:",
                    style: boldTextStyle(
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  /*TextSpan(
                    text: " :",
                    style: boldTextStyle(
                      size: 24,
                      color: const Color.fromARGB(255, 252, 248, 2),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
          16.height,
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                eventoImagen,
                width: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          20.height,
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 450,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(.30),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: const [
                    Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 60,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Escanear QR",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ).onTap(
                () => const CheckerScannerScreen().launch(context),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),
          ),

          80.height,
        ],
      ),
    );
  }
}
