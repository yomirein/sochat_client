import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/modules/common/auth_service.dart';
import 'package:sochat_client/modules/keys/key_service.dart';
import 'package:sochat_client/so_ui/common/so_exception.dart';
import 'package:sochat_client/so_ui/loginscreen/login_screen.dart';
import 'package:sochat_client/so_ui/loginscreen/widgets/login_button.dart';
import 'package:sochat_client/so_ui/loginscreen/widgets/login_input.dart';
import 'package:sochat_client/so_ui/loginscreen/widgets/settings_button.dart';
import 'package:sochat_client/so_ux/login_controller.dart';

class LoginWidget extends ConsumerStatefulWidget {

  LoginWidget({super.key});

  @override
  LoginPageWidget createState() => LoginPageWidget();
}

class LoginPageWidget extends ConsumerState<LoginWidget> {

    TextEditingController _usernameController = TextEditingController();

    String errorText = "";
    void setError(String text){
      setState(() {
        errorText = text;
      });

    }

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider);
    final keyService = ref.read(keyServiceProvider);

    final loginController = ref.read(loginControllerProvider.notifier);

    return Padding(
      padding: EdgeInsetsGeometry.directional(top: 20, bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 8,
        children: [
          Text("So"),
          Column(
            spacing: 8,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoginInput(hintText: "Username", inputController: _usernameController, height: 52, onChanged: (text) {
                    setError("");
                  },),
                  Text(errorText,   style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: context.colors.critical,
                    fontWeight: FontWeight.bold,
                  ),),
                ],
              ),
              Row(
                spacing: 8,
                children: [
                  Expanded(child: LoginButton(text: "Login", color: context.colors.primary, onTap: () async {
                    setError("");
                    try {
                      await loginController.login(
                          context,
                          _usernameController.text,
                          ref.read(selectedProfileProvider),
                          ref.read(selectedServerProvider),
                          ref
                      );
                    } on SocketException catch (e) {
                      setError(e.message);
                    } on SoException catch (e) {
                      setError(e.cause);
                    } catch (e) {
                      setError("Unknown error: $e");
                    }
                  })),
                  SettingsButton(Icons.settings, size: 43, onPressed: () {ref.read(settingsToggle.notifier).state = !ref.read(settingsToggle);}),
                ],
              ),
              LoginButton(text: "Register", color: context.colors.positive, onTap: () {
                setError("");
                try {
                  loginController.register(context, _usernameController.text,
                      ref.read(selectedProfileProvider), ref.read(selectedServerProvider), ref);
                } on SocketException catch (e) {
                  setError(e.message);
                } on SoException catch (e) {
                  setError(e.cause);
                } catch (e) {
                  setError("Unknown error: $e");
                }
              }),
            ],
          )
        ],
      ),
    );
  }
}