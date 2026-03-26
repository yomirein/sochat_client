import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/settings_window/account/account.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/settings_window/appearance/appearance.dart';
import 'package:sochat_client/so_ui/common/so_button.dart';
import 'package:sochat_client/so_ui/themes/dark/dark_theme.dart';
import 'package:sochat_client/so_ui/themes/light/light_theme.dart';
import 'package:sochat_client/so_ux/settings_controller.dart';

class SettingsWindow extends ConsumerStatefulWidget {
  const SettingsWindow({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SettingsWindowState();
}

class SettingsWindowState extends ConsumerState<SettingsWindow>{


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedOption = ref.watch(selectedSettingsOptionProvider);
    final settingsController = ref.read(settingsControllerProvider.notifier);

    return Expanded(
      flex: 2,
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: context.colors.outline,
                width: 1.0,
              ),
              color: context.colors.foreground,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: _buildOptions(selectedOption, settingsController)
      ),
    );


  }

  Widget _buildOptions(int selectedOption, SettingsController settingsController) {
    switch (selectedOption) {
      case 1:
        return Account();
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Text("In future"),
          ],
        );
      case 3:
        return Appearance();
      default:
        return Column(children: [

        ],);
    }
  }


}