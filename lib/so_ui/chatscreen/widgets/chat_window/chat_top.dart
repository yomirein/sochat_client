import 'package:flutter/material.dart';
import 'package:sochat_client/extenstions/hex_color.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/top_button.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/so_ux/chatscreen/chat_controller.dart';

class ChatTop extends ConsumerWidget {
  const ChatTop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatController = ref.read(chatControllerProvider.notifier);
    final chatList = ref.watch(chatsListProvider);
    final selectedChat = ref.watch(selectedChatProvider);

    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide.none,
          left: BorderSide.none,
          right: BorderSide.none,
          bottom: BorderSide(
            color: context.colors.outline,
            width: 1,
          ),
        ),
        color: context.colors.foreground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 10,
              children: [
                CircleAvatar(radius: 20, child: Text(chatList.firstWhere((chat) => chat.id == selectedChat!.id).name[0])),
                Text(chatList.firstWhere((chat) => chat.id == selectedChat!.id).name)
              ],
            ),

            Row(
              spacing: 10,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  child: Material(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(10),
                    color: context.colors.foreground,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () { ref.read(isInCallProvider.notifier).state = true; print("set true");},
                      child: Icon(Icons.call),
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  child: Material(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(10),
                    color: context.colors.foreground,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: Icon(Icons.video_call),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}