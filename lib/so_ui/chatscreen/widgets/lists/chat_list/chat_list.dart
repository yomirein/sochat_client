import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/hex_color.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/modules/chats/chat_service.dart';
import 'package:sochat_client/modules/common/auth_service.dart';
import 'package:sochat_client/so_ux/chatscreen/chat_controller.dart';
import 'chat_item.dart';

class ChatList extends ConsumerWidget {
  const ChatList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatListProvider = ref.watch(chatsListProvider);

    final chatController = ref.read(chatControllerProvider.notifier);

    final authService = ref.watch(authServiceProvider);
    final chatService = ref.read(chatsServiceProvider.notifier);



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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                ...chatListProvider.map((e) => ChatItem(
                  nickname: e.name, description: "No description", lastMessage: "No last message",
                  onPressed: () async { await chatController.openChat(e.name);},
                )),],
            ),
            /*
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChatItem(nickname: "Nick", description: "another autism", lastMessage: "I HATE YOU I HATE YOU I HATE YOU DIEI HATE YOU I HATE YOU I HATE YOU DIEoverflow: TextOverflow.ellipsis",),
            ],
          ),*/
          )
      )
    );
  }
}