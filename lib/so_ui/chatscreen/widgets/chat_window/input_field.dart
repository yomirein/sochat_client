import 'package:flutter/material.dart';
import 'package:sochat_client/extenstions/hex_color.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/so_ux/chatscreen/chat_controller.dart';

class InputField extends ConsumerWidget {
  const InputField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController messageInputController = TextEditingController();
    final chatContoller = ref.watch(chatControllerProvider.notifier);


    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.colors.outline,
            width: 1,
          ),
          left: BorderSide.none,
          right: BorderSide.none,
          bottom: BorderSide.none,
        ),
        color: context.colors.foreground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: 180
              ),
              child: TextField(
                keyboardType: TextInputType.multiline,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: null,
                controller: messageInputController,
                minLines: 1,
                decoration: InputDecoration(hintText: "Type message here",
                  hintStyle: Theme.of(context).textTheme.labelMedium,
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
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
                      onTap: () {},
                      child: Icon(Icons.emoji_emotions_outlined),
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
                      onTap: () {
                        chatContoller.sendMessage(messageInputController.text);
                        messageInputController.text = "";
                        },
                      child: Icon(Icons.send_sharp),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}