import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/so_ui/loginscreen/widgets/keys/keys_list.dart';
import 'package:sochat_client/so_ui/loginscreen/widgets/keys/server_list.dart';
import 'package:sochat_client/so_ui/loginscreen/widgets/settings_button.dart';

import 'login_screen.dart';

class KeySettings extends ConsumerWidget {

  const KeySettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SettingsButton(Icons.arrow_back_outlined, size: 43, onPressed: () {ref.read(settingsToggle.notifier).state = !ref.read(settingsToggle);},),
            ],
          ),
          Expanded(
            child: Row(
              spacing: 8,
              children: [
                ServerList(),
                KeysList()
              ],
            ),
          ),
        ],
      );
  }
}