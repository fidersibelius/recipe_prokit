import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bitsoftickets/components/RCFooterComponent.dart';
import 'package:bitsoftickets/services/AuthStorage.dart';
import 'package:bitsoftickets/screens/RCSignUpScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RCProfileScreen extends StatefulWidget {
  const RCProfileScreen({super.key});

  @override
  State<RCProfileScreen> createState() => _RCProfileScreenState();
}

class _RCProfileScreenState extends State<RCProfileScreen> {
  String username = "Usuario";
  String roleLabel = "Sin permisos";

  @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

  Future<void> cargarUsuario() async {
    final user = await AuthStorage.getUser();
    final capabilities = await AuthStorage.getCapabilities();

    if (!mounted) {
      return;
    }

    setState(() {
      username = user ?? username;
      roleLabel = capabilities.roleLabel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final version = dotenv.env['APP_VERSION'] ?? '1.0.0';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Perfil'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        30.height,
                        const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(
                            'images/usuario_avatar.png',
                          ),
                        ),
                        20.height,
                        Text(
                          username,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: boldTextStyle(
                            size: 24,
                          ),
                        ),
                        6.height,
                        Text(
                          roleLabel,
                          textAlign: TextAlign.center,
                          style: secondaryTextStyle(
                            size: 16,
                          ),
                        ),
                        40.height,
                        const Divider(),
                        24.height,
                        SizedBox(
                          width: 220,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              await AuthStorage.clear();

                              if (!context.mounted) {
                                return;
                              }

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RCSignUpScreen(
                                    selectedIndex: 1,
                                  ),
                                ),
                                (route) => false,
                              );
                            },
                            icon: const Icon(
                              Icons.logout,
                            ),
                            label: const Text(
                              'Cerrar sesión',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(
                                color: Colors.red,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 24,
                              ),
                              shape: const StadiumBorder(),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 17,
                                color: Colors.grey.shade600,
                              ),
                              7.width,
                              Text(
                                'Versión $version',
                                style: secondaryTextStyle(
                                  size: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        18.height,
                        const RCFooterComponent(),
                        24.height,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
