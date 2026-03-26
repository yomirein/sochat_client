import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sochat_client/context/notifications/notifications_manager.dart';
import 'package:sochat_client/modules/chats/chat.dart';
import 'package:sochat_client/modules/chats/chat_service.dart';
import 'package:sochat_client/modules/chats/sender_key.dart';
import 'package:sochat_client/modules/users/user_service.dart';
import 'package:sochat_client/modules/websocket/message_packet.dart';
import 'package:sochat_client/modules/users/user.dart';
import 'package:sochat_client/modules/websocket/web_socket_service.dart';
import 'package:sochat_client/so_ui/notifications/so_notification.dart';
import 'package:sochat_client/so_ux/chat_controller.dart';

import '../common/auth_service.dart';
import '../keys/key_service.dart';
import 'message.dart';


final messageServiceProvider = StateNotifierProvider<MessageService, MessagesState>(
      (ref) => MessageService(ref.read(webSocketProvider), ref.read(keyServiceProvider.notifier), ref.read(authServiceProvider), ref.read(chatsServiceProvider.notifier), ref.read(userServiceProvider.notifier), ref),);



class MessagesState {

  MessagesState();


}

class MessageService extends StateNotifier<MessagesState> {
  final WebSocketService _webSocket;
  final KeyService _keyService;
  final AuthService _authService;
  final ChatService _chatService;
  final UserService _userService;

  Ref ref;
  StreamSubscription? _subscription;

  MessageService(this._webSocket, this._keyService, this._authService, this._chatService, this._userService, this.ref)
      : super(MessagesState()) {
    startListen();
  }


  void startListen() {
    _subscription = _webSocket.messagesMessages.listen((message) {
      switch(message.type){
        case "message_send":{
          if (message.payload["success"] == "true"){
            break;
          }
          Chat chat = ref.read(chatsListProvider).firstWhere((c) => c.id == jsonDecode(message.payload["message"] as String)["chatId"]);

          receiveMessage(message, chat);
          break;
        }
        case "message_edit":{
          break;
        }
        case "message_delete":{
          break;
        }
        case "message_read":{
          receiveLastReadMessage(message);
          break;
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> getRecentMessages(Chat chat, int offset, {atStart = true}) async {
    /*if (offset == 0 && ref.read(chatMessagesProvider).containsKey(chat.id) && ref.read(chatMessagesProvider)[chat.id]!.length > 2){
      return;
    }
    */

    MessagePacket message = MessagePacket(type: "message_list", payload: {
      "offset": offset,
      "chatId": chat.id,
    });
    final request = await _webSocket.sendRequest(message);

    List<dynamic> messageList = jsonDecode(request.payload["messages"]);


    for (final message in messageList.reversed){
      try {
        message['content'] = await _keyService.decryptWithAes(message['content'], chat.findChatKeyByVersion(message['keyVersion'])!.key);

        User user = chat.participants.any((p) => p.user.id == message["senderId"])
            ? chat.participants.firstWhere((p) => p.user.id == message["senderId"]).user
            : ((await _userService.getUser(id: message["senderId"])));
        addMessage(Message.fromJson(message, user), atStart: atStart);
      }catch (e){
        print("no");
      }
    }
  }

  Future<void> getMessage(int messageId, Chat? chat) async {
    MessagePacket message = MessagePacket(type: "message_get", payload: {
      "messageId": messageId,
    });
    final request = await _webSocket.sendRequest(message);
    receiveMessage(request, chat);
  }


  Future<void> sendMessage(String content, int? replyMessageId, Chat chat) async{
    String encryptedContent = await _keyService.encryptWithAes(content, chat.findLatestChatKey()!.key);

    for (SenderKey senderKey in chat.chatKeys){
      print("senderkey: ${senderKey.keyVersion}: ${senderKey.key}");
    }

    MessagePacket message = MessagePacket(type: "message_send", payload: {
      "content": encryptedContent,
      "replyMessageId": replyMessageId,
      "chatId": chat.id
    });
    final request = await _webSocket.sendRequest(message);

    if (request.payload["success"] == "true"){
      receiveMessage(request, chat);
    }
  }

  Future<void> receiveMessage(MessagePacket requestPacket, Chat? chat) async{

    chat ??= await _chatService.getChatById(int.parse(requestPacket.payload["chatId"]));
    if (chat.chatKeys == []){
      _chatService.getChatById(chat.id);
    }

    final messageJson = jsonDecode(requestPacket.payload["message"]);

    messageJson['content'] = await _keyService.decryptWithAes(messageJson['content'], chat.findChatKeyByVersion(messageJson['keyVersion'])!.key);

    late Message message;
    if (chat.participants.any((p) => p.user.id == messageJson["senderId"]!)){
      message = Message.fromJson(messageJson, chat.participants.firstWhere((p) => p.user.id == messageJson["senderId"]!).user);
    }
    else {
      User sender = (await _userService.getUser(username: messageJson["senderId"]));
      message = Message.fromJson(
          jsonDecode(requestPacket.payload["message"]), sender);
    }
    addMessage(message);

  }

  void addMessage(Message message, {bool atStart = true}) {
    final notifier = ref.read(chatMessagesProvider.notifier);
    final currentMap = notifier.state;
    final currentMessages = List<Message>.from(
      currentMap[message.chatId] ?? [],
    );

    if (currentMessages.any((m) => m.id == message.id)) return;

    currentMessages.add(message);

    currentMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    final updatedMap2 = {
      ...currentMap,
      message.chatId: currentMessages,
    };

    notifier.state = updatedMap2;
  }

  Future<void> receiveLastReadMessage(MessagePacket requestPacket) async {
    Map<String, dynamic> participantJson = jsonDecode(requestPacket.payload["participant"]);
    _chatService.updateParticipantLastRead(participantJson["chatId"], participantJson["userId"], participantJson["lastMessageId"]);
  }

  Future<void> readLastMessage(int id) async {

    MessagePacket message = MessagePacket(type: "message_read", payload: {
      "id": id,
    });
    final request = await _webSocket.sendRequest(message);
    receiveLastReadMessage(request);
  }
}
