import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:sochat_client/modules/chats/chat.dart';
import 'package:sochat_client/modules/chats/chat_service.dart';
import 'package:sochat_client/modules/keys/key.dart';
import 'package:sochat_client/modules/messages/message.dart';
import 'package:sochat_client/modules/messages/message_service.dart';
import 'package:sochat_client/modules/websocket/message_packet.dart';
import 'package:sochat_client/modules/users/user.dart';
import 'package:sochat_client/modules/websocket/web_socket_service.dart';
import 'package:sochat_client/so_ui/chatscreen/chat_screen.dart';

final chatControllerProvider = StateNotifierProvider<ChatController, ChatControllerState>((ref) {
  final chatService = ref.read(chatsServiceProvider.notifier);
  final messageService = ref.read(messageServiceProvider.notifier);

  return ChatController(chatService, messageService, ref);
});

final selectedChatProvider = StateProvider<Chat?>((ref) => null);
final isInCallProvider = StateProvider<bool>((ref) => false);
final chatMessagesProvider = StateProvider<Map<int,List<Message>>>((ref) => {});


final chatsListProvider = Provider<List<Chat>>((ref) {
  final chats = ref.watch(chatsServiceProvider).chatList;
  return chats;
});

class ChatControllerState {

}

class ChatController extends StateNotifier<ChatControllerState> {
  ChatService _chatService;
  MessageService _messageService;
  Ref ref;


  ChatController(this._chatService, this._messageService, this.ref) : super(ChatControllerState());

  Future<void> openChat(String username) async{
    final selectedChat = await _chatService.getChatByName(username);
    await _messageService.getRecentMessages(selectedChat, 20);
    ref.read(selectedChatProvider.notifier).state = selectedChat;
  }

  Future<void> sendMessage(String content) async {
    final selectedChat = ref.read(selectedChatProvider.notifier).state;
    await _messageService.sendMessage(content, null, selectedChat!);
  }

}