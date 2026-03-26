import 'package:sochat_client/modules/chats/chat_role.dart';
import 'package:sochat_client/modules/users/user.dart';

class Participant {

  User user;
  ChatRole chatRole;
  int lastReadMessageId;

  Participant({required this.user, required this.chatRole, this.lastReadMessageId = 0});

  Participant copyWith({
    User? user,
    ChatRole? chatRole,
    int? lastReadMessageId,
  }) {
    return Participant(
      user: user ?? this.user,
      chatRole: chatRole ?? this.chatRole,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
    );
  }

}