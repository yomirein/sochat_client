import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sochat_client/context_menu/menus.dart';
import 'package:sochat_client/modules/chats/chat_service.dart';
import 'package:sochat_client/modules/common/auth_service.dart';
import 'package:sochat_client/modules/friends/friends_service.dart';
import 'package:sochat_client/modules/websocket/web_socket_service.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/avatar_button.dart';
import 'package:sochat_client/extenstions/hex_color.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/lists/chat_list/chat_list.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/chat_window/chat_window.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/lists/friend_list/friend_list.dart';
import 'package:sochat_client/so_ui/common/input.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/search/search_list.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/search_button.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/top_button.dart';
import 'package:sochat_client/context_menu/context_window.dart';
import 'package:sochat_client/context_menu/context_menu_button.dart';

import 'package:sochat_client/context_menu/context_menu.dart';
import 'package:sochat_client/so_ui/loginscreen/widgets/keys/keys_button.dart';
import 'package:sochat_client/so_ux/chatscreen/chat_controller.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

final activeList = StateProvider<int>((ref) => 0);

class _ChatScreenState extends ConsumerState<ChatScreen> {

  @override
  void initState() {

    final chatController = ref.read(chatControllerProvider.notifier);
    chatController.getChatList();
    chatController.getFriendsList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);
    final webSocketService = ref.watch(webSocketProvider);
    final active = ref.watch(activeList);

    final chatController = ref.watch(chatControllerProvider.notifier);

    final blockedRelativesList = ref.watch(blockedListProvider);
    final friendRelativesList = ref.watch(friendsListProvider);
    final incomingRelativesList = ref.watch(incomingRequestsProvider);
    final outgoingRelativesList = ref.watch(outgoingRequestsProvider);

    return Scaffold(
      body: Stack(children: [Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16, top: 8),
        child: Column(
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    TopButton(Icons.sms, onPressed: () { ref.read(activeList.notifier).state = 0; },),
                    TopButton(Icons.person, onPressed: () { ref.read(activeList.notifier).state = 1; },),
                    TopButton(Icons.settings, onPressed: () { ref.read(activeList.notifier).state = 2; },),
                    ],
                ),
                Expanded(child: Container()),
                Expanded(flex: 4, child: SearchButton(
                    onPressed: Menus.openSearchWindow(context, ref))
                ),
                Expanded(child: Container()),

                Row(
                  spacing: 10,
                  children: [
                    TopButton(Icons.inbox_rounded),
                    AvatarButton(user: authService.currentUser!),
                  ],
                ),
              ],
            ),
            Expanded(child:
            Row(
              spacing: 16,
              children: [
                if (active == 0) ChatList(),
                if (active == 1) FriendList(),
                ChatWindow(),
              ],
            ),
            ),
          ],
        ),
      ),
    ]),
    );
  }
}
