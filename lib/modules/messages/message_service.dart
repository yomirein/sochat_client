
import 'dart:convert';
import 'dart:ffi';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sochat_client/modules/chats/chat.dart';
import 'package:sochat_client/modules/chats/chat_service.dart';
import 'package:sochat_client/modules/websocket/message_packet.dart';
import 'package:sochat_client/modules/users/user.dart';
import 'package:sochat_client/modules/websocket/web_socket_service.dart';
import 'package:sochat_client/so_ux/chatscreen/chat_controller.dart';

import '../common/auth_service.dart';
import '../keys/key_service.dart';
import 'message.dart';


final messageServiceProvider = StateNotifierProvider<MessageService, MessagesState>(
      (ref) => MessageService(ref.read(webSocketProvider), ref.read(keyServiceProvider.notifier), ref.read(authServiceProvider), ref.read(chatsServiceProvider.notifier), ref),);



class MessagesState {
  final List<Message> messageList;

  MessagesState({required this.messageList});

  MessagesState copyWith({
    List<Message>? messages,
  }) {
    return MessagesState(
      messageList: messages ?? this.messageList,
    );
  }

}

class MessageService extends StateNotifier<MessagesState> {
  final WebSocketService _webSocket;
  final KeyService _keyService;
  final AuthService _authService;
  final ChatService _chatService;

  Ref ref;

  MessageService(this._webSocket, this._keyService, this._authService, this._chatService, this.ref)
      : super(MessagesState(messageList: [])) {
    startListen();
  }


  void startListen() {
    _webSocket.messagesMessages.listen((message) {
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
      }
    });
  }

  Future<void> getRecentMessages(Chat chat, int limit) async {
    MessagePacket message = MessagePacket(type: "message_list", payload: {
      "limit": limit,
      "chatId": chat.id,
    });
    final request = await _webSocket.sendRequest(message);

    List<dynamic> messageList = jsonDecode(request.payload["messages"]);

    for (final message in messageList.reversed){
      message['content'] = await _keyService.decryptWithAes(message['content'], chat.chatKey!);
      addMessage(Message.fromJson(message, (await _webSocket.getUserById(message["senderId"])).key));
    }
  }

  Future<void> getMessage(int messageId) async {
    MessagePacket message = MessagePacket(type: "message_get", payload: {
      "messageId": messageId,
    });
    final request = await _webSocket.sendRequest(message);
    receiveMessage(request, null);
  }


  Future<void> sendMessage(String content, int? replyMessageId, Chat chat) async{

    // TODO: Make encrypt content method in KeyService
    String encryptedContent = await _keyService.encryptWithAes(content, chat.chatKey!);

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

    // TODO: Make decrypt content method

    final messageJson = jsonDecode(requestPacket.payload["message"]);

    messageJson['content'] = await _keyService.decryptWithAes(messageJson['content'], chat.chatKey!);

    late Message message;
    if (chat.participants.any((u) => u.id == messageJson["senderId"]!)){
      message = Message.fromJson(messageJson, chat.participants.firstWhere((u) => u.id == messageJson["senderId"]!));
    }
    else {
      User sender = (await _webSocket.getUserById(messageJson["senderId"]))
          .key;
      message = Message.fromJson(
          jsonDecode(requestPacket.payload["message"]), sender);
    }
    addMessage(message);
  }


  void addMessage(Message message) {

    final notifier = ref.read(chatMessagesProvider.notifier);
    final currentMap = notifier.state;
    final currentMessages = currentMap[message.chatId] ?? [];

    final updatedMap = {
      ...currentMap,
      message.chatId: [...currentMessages, message],
    };

    notifier.state = updatedMap;
  }
}
