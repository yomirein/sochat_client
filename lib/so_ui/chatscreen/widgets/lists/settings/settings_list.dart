import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/modules/common/auth_service.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/lists/settings/settings_item.dart';
import 'package:sochat_client/so_ui/themes/light/light_theme.dart';
import 'package:sochat_client/so_ux/chat_controller.dart';
import 'package:sochat_client/so_ux/login_controller.dart';
import 'package:sochat_client/so_ux/settings_controller.dart';

class SettingsList extends ConsumerWidget {
  const SettingsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final loginController = ref.read(loginControllerProvider.notifier);
    
    return Expanded(
      flex: 1,
      child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            border: Border.all(
              color: context.colors.outline,
              width: 1.0,
            ),
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(10.0),
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SettingsItem(title: "Account", trailing: Icon(Icons.person, size: 30,), onPressed: () { ref.read(selectedSettingsOptionProvider.notifier).state = 1; }),
                SettingsItem(title: "Notifications", trailing: Icon(Icons.notifications, size: 30), onPressed: () { ref.read(selectedSettingsOptionProvider.notifier).state = 2; }),
                SettingsItem(title: "Appearance", trailing: Icon(Icons.palette, size: 30), onPressed: () { ref.read(selectedSettingsOptionProvider.notifier).state = 3; }),
              ],
            ),
            SettingsItem(title: "Log-out", trailing: Icon(Icons.logout, size: 30), onPressed: () { loginController.logout(context); }),
          ],
        ),
      )
    );
  }
}