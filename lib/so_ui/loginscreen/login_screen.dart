import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/modules/keys/key_service.dart';
import 'package:sochat_client/so_ui/loginscreen/keysettings.dart';
import 'package:sochat_client/so_ui/loginscreen/login_widget.dart';
import 'package:sochat_client/so_ui/loginscreen/widgets/login_button.dart';
import 'package:sochat_client/so_ui/loginscreen/widgets/login_input.dart';
import 'package:sochat_client/so_ui/loginscreen/widgets/settings_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsToggle = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  @override
  void initState() {
    super.initState();
    final keyService = ref.read(keyServiceProvider.notifier);
    Future.microtask(() {
      keyService.generateProfile();
      keyService.addServer("yom", "http://localhost:8081");
      keyService.addServer("yomr", "http://localhoqedqst:8081");
      keyService.addServer("yomra", "http://localhasdawqeost:8081");
      keyService.addServer("yomasd", "http://localhoasdasdst:8081");

    });
  }

  @override
  Widget build(BuildContext context) {
    final toggle = ref.watch(settingsToggle);

    ref.watch(selectedProfileProvider);
    ref.watch(selectedServerProvider);
    ref.watch(keyServiceProvider);
    ref.watch(keyServiceProvider.notifier);

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 550,
          height: 350,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: context.colors.outline,
                  width: 1.0,
                ),
                color: context.colors.surface
            ),
            padding: EdgeInsets.all(16),
            child: toggle ? KeySettings() : LoginWidget()
          ),
        ),
      ),
    );
  }
}