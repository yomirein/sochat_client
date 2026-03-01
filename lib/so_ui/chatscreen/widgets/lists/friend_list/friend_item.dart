import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/context_menu/menus.dart';
import 'package:sochat_client/context_menu/context_manager.dart';
import 'package:sochat_client/context_menu/context_menu.dart';
import 'package:sochat_client/extenstions/hex_color.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/context_menu/context_menu_button.dart';
import 'package:sochat_client/so_ui/common/icon_button.dart';


class FriendItem extends ConsumerWidget {
  const FriendItem({
    super.key,
    required this.nickname,
    this.description = "",
    this.trailing,
    this.menuItems,
  });

  final String nickname;
  final String description;
  final Widget? trailing;
  final List<ContextMenuButton>? menuItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextManager = ref.read(contextManagerProvider);

    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {},
        onSecondaryTapDown: (details) {

          if (menuItems == null) {
            final menuItems = Menus.friendContext(context, ref, nickname, description);
            showContextMenu(
              context,
              details.globalPosition,
              items: menuItems,
              ref,
            );
          }
          else {
            showContextMenu(
              context,
              details.globalPosition,
              items: menuItems!,
              ref,
            );
          }

        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      child: Text(nickname[0]),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        nickname,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}