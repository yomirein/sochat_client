import 'package:cryptography/cryptography.dart';
import 'package:sochat_client/modules/chats/chat_role.dart';
import 'package:sochat_client/modules/chats/sender_key.dart';
import 'package:sochat_client/modules/messages/message.dart';
import 'package:sochat_client/modules/users/user.dart';

import 'chat_type.dart';

class Chat {
  int id;
  String title;
  ChatType type;

  List<Message>? messages;

  List<SenderKey> chatKeys = [];
  Map<User, ChatRole> participants = {};


  Chat({
    required this.id,
    required this.title,
    required this.type,
  });

  SenderKey? findChatKeyByVersion(int version) {
    for (var sk in chatKeys!) {
      if (sk.keyVersion == version) return sk;
    }
    return null;
  }
  SenderKey? findLatestChatKey() {
    if (chatKeys!.isEmpty) return null;

    SenderKey latest = chatKeys!.first;
    for (var sk in chatKeys!) {
      if (sk.keyVersion > latest.keyVersion) {
        latest = sk;
      }
    }
    return latest;
  }


}