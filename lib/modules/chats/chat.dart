import 'package:cryptography/cryptography.dart';
import 'package:sochat_client/modules/messages/message.dart';
import 'package:sochat_client/modules/users/user.dart';

class Chat {
  int id;
  String name;
  List<User> participants;
  List<Message>? messages;

  SecretKey? chatKey;

  Chat({
    required this.id,
    required this.name,
    this.chatKey,
    required this.participants,
  });
}