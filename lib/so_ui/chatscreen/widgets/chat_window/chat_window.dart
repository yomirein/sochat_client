import 'package:flutter/material.dart';
import 'package:sochat_client/modules/users/user.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/chat_window/calls/call_window.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/chat_window/message_list.dart';
import 'package:sochat_client/extenstions/hex_color.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/chat_window/chat_top.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/chat_window/input_field.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/modules/messages/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/so_ux/chatscreen/chat_controller.dart';

class ChatWindow extends ConsumerWidget {
  const ChatWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectedChat = ref.watch(selectedChatProvider);
    final isInCall = ref.watch(isInCallProvider);

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
        child: selectedChat != null
            ? (isInCall
            ? Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CallWindow()
          ],
        ): Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ChatTop(),
            Container(child: MessageList()),
            InputField()
          ],
        )): Column(children: [],)
      ),
    );
  }
}