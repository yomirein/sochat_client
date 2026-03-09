import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/context_menu/menus.dart';
import 'package:sochat_client/context_menu/context_manager.dart';
import 'package:sochat_client/context_menu/context_menu.dart';
import 'package:sochat_client/extenstions/hex_color.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/context_menu/context_menu_button.dart';
import 'package:sochat_client/modules/chats/chat.dart';

class ChatItem extends ConsumerWidget {
  ChatItem({
    super.key,
    required this.chat,
    this.lastMessage = "",
    this.description = "",
    this.onPressed,
  });

  final Chat chat;
  String lastMessage = "";
  String description = "";
  GestureTapCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextManager = ref.read(contextManagerProvider);
    
      return Material(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          onSecondaryTapDown: (details) {
            List<ContextMenuButton> menuItems = Menus.userContext(context, ref, chat, description);
            showContextMenu(context, details.globalPosition, items: menuItems, ref);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                CircleAvatar(radius: 25, child: Text(chat.title[0])),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        lastMessage,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.labelMedium,
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
