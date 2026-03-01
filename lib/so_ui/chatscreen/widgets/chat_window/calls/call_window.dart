import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/chat_window/calls/user_in_call.dart';
import 'package:sochat_client/so_ui/common/icon_button.dart';

import '../../../../../so_ux/chatscreen/chat_controller.dart';

class CallWindow extends ConsumerWidget {
  const CallWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectedChat = ref.watch(selectedChatProvider);

    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: context.colors.outline,
            width: 1.0,
          ),
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                spacing: 10,
                children: [
                  SoIconButton(Icons.arrow_back, height: 30, width: 30,  color: Colors.transparent, onPressed: () {},),
                  CircleAvatar(radius: 20, child: Text("S")),
                  Text("silver")
                ],
              ),
              Expanded(
                flex: 5,
                child: Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UserInCall(userId: 1),
                    UserInCall(userId: 1)
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SoIconButton(Icons.call_end, height: 60, width: 75,  color: context.colors.critical, onPressed: () {},),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}