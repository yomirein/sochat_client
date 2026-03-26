import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/context/menus.dart';
import 'package:sochat_client/context/notifications/notifications_manager.dart';
import 'package:sochat_client/extenstions/hex_color.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/extenstions/utils.dart';
import 'package:sochat_client/modules/chats/chat_role.dart';
import 'package:sochat_client/modules/chats/chat_service.dart';
import 'package:sochat_client/modules/chats/participant.dart';
import 'package:sochat_client/modules/common/auth_service.dart';
import 'package:sochat_client/modules/messages/message_service.dart';
import 'package:sochat_client/modules/users/user.dart';
import 'package:sochat_client/modules/users/user_service.dart';
import 'package:sochat_client/so_ui/common/so_button.dart';
import 'package:sochat_client/so_ui/loginscreen/widgets/keys/keys_button.dart';
import 'package:sochat_client/so_ui/notifications/so_notification.dart';
import 'package:sochat_client/so_ux/chat_controller.dart';
import 'chat_item.dart';
import 'package:collection/collection.dart';

class ChatList extends ConsumerWidget {
  const ChatList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatListProvider = ref.watch(chatsListProvider);
    final chatController = ref.watch(chatControllerProvider.notifier);
    final authService = ref.watch(authServiceProvider);
    final messageMap = ref.watch(chatMessagesProvider);
    final currentUser = ref.watch(currentUserProvider);

    final sortedChats = [...chatListProvider]..sort((a, b) {
      final messagesA = messageMap[a.id] ?? [];
      final messagesB = messageMap[b.id] ?? [];

      DateTime lastA = messagesA.isNotEmpty ? messagesA.first.timestamp : DateTime.now();
      DateTime lastB = messagesB.isNotEmpty ? messagesB.first.timestamp : DateTime.now();

      return lastB.compareTo(lastA);
    });

    return Expanded(
      flex: 1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
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

                    ...sortedChats.map((e) {
                      final messageMap = ref.read(chatMessagesProvider);
                      final messages = messageMap[e.id] ?? [];
                      final hasMessages = messages.isNotEmpty;
                      final lastMessage = hasMessages ? messages.first : null;

                      final isCurrentUser = lastMessage != null &&
                          currentUser!.id == lastMessage.sender.id;
                      final isRead = lastMessage != null
                          ? e.participants.any((p) => p.lastReadMessageId >= lastMessage.id && p.user.id == currentUser!.id)
                          : null;

                      final myParticipant = e.participants.firstWhere(
                            (p) => p.user.id == currentUser!.id,
                      );

                      final lastReadId = myParticipant.lastReadMessageId;

                      final unReadMessageCount = messages
                          .where((m) => m.id > lastReadId && m.sender.id != currentUser!.id)
                          .length;

                      return ChatItem(
                          chatId: e.id,
                          clientId: currentUser!.id,
                          description: "No description",
                          lastMessage: lastMessage,
                          isRead: isRead,
                          time: hasMessages
                              ? Utils.buildDateString(lastMessage!.timestamp)
                              : "",
                          onPressed: () async {
                          await chatController.openChat(e);
                        }, unReadMessageCount: unReadMessageCount
                      );
                    }).toList(),],
                ),
              )
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: SoButton(
                width: 60, height: 60, color: context.colors.primary,
                onPressed: Menus.createChatDialog(context, ref) ,
                child: Icon(Icons.add, size: 45, color: Colors.white,),
              )
          ),
        ],
      )
    );
  }
}