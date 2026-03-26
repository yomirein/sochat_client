import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sochat_client/context/menus.dart';
import 'package:sochat_client/modules/common/auth_service.dart';
import 'package:sochat_client/modules/friends/friends_service.dart';
import 'package:sochat_client/modules/websocket/web_socket_service.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/avatar_button.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/lists/chat_list/chat_list.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/chat_window/chat_window.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/lists/friend_list/friend_list.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/lists/settings/settings_list.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/search_button.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/settings_window/settings_window.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/top_button.dart';

import 'package:sochat_client/so_ux/chat_controller.dart';

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
    final active = ref.watch(activeList);

    final currentUser = ref.watch(currentUserProvider);

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
                    AvatarButton(user: currentUser!,),
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
                if (active == 2) SettingsList(),
                ([0,1].contains(active)) ? ChatWindow() : SettingsWindow(),
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
