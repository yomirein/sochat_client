import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/context/menus.dart';
import 'package:sochat_client/context/context_manager.dart';
import 'package:sochat_client/context/context_menu.dart';
import 'package:sochat_client/context/context_menu_button.dart';
import 'package:sochat_client/modules/users/user.dart';
import 'package:sochat_client/so_ui/common/so_button.dart';


class SettingsItem extends ConsumerWidget {
  const SettingsItem({
    super.key,
    required this.title,
    this.trailing,
    this.color, this.onPressed,
  });

  final String title;
  final VoidCallback? onPressed;
  final Widget? trailing;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color buttonColor = color ?? Colors.transparent;

    return Material(
      color: buttonColor,
      borderRadius: BorderRadius.circular(10),
      child: SoButton(
        height: 70,
        color: buttonColor,
        width: double.infinity,
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  spacing: 10,
                  children: [
                    if (trailing != null) trailing!,
                    Expanded(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}