import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:sochat_client/extenstions/hex_color.dart';
import 'package:sochat_client/modules/messages/message.dart';
import 'package:sochat_client/so_ux/chatscreen/chat_controller.dart';


class MessageList extends ConsumerStatefulWidget {
  MessageList({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MessageListState();
}

class MessageListState extends ConsumerState<MessageList>{
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final chatController = ref.read(chatControllerProvider.notifier);

    _controller.addListener(() {
      if (_controller.offset >= _controller.position.maxScrollExtent) {
        chatController.loadRecentMessages();
      }
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageMap = ref.watch(chatMessagesProvider);
    final selectedChat = ref.watch(selectedChatProvider);

    messageMap[selectedChat!.id] ??= [];
    return Expanded(
        child: SelectionArea(
          child: ListView.builder(controller: _controller, reverse: true, itemCount: messageMap[selectedChat.id]!.length, itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                  ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    CircleAvatar(
                      radius: 19,
                      child: Text(messageMap[selectedChat.id]![index].sender.username[0]),
                    ),
                    Expanded(
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 4,
                            children: [
                              Text(
                                messageMap[selectedChat.id]![index].sender.username,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                "${messageMap[selectedChat.id]![index].timestamp}}",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                          Text(
                            messageMap[selectedChat.id]![index].content,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
            );
          }
          ),
        ),
    );
  }
}