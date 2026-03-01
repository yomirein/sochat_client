 
import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sochat_client/modules/chats/chat.dart';
import 'package:sochat_client/modules/websocket/message_packet.dart';
import 'package:sochat_client/modules/users/user.dart';
import 'package:sochat_client/modules/websocket/web_socket_service.dart';

import '../common/auth_service.dart';
import '../keys/key_service.dart';

final chatsServiceProvider = StateNotifierProvider<ChatService, ChatsState>(
      (ref) => ChatService(ref.read(webSocketProvider), ref.read(keyServiceProvider.notifier), ref.read(authServiceProvider), ref),);



class ChatsState {
  final List<Chat> chatList;

  ChatsState({required this.chatList});

  ChatsState copyWith({
    List<Chat>? chats,
  }) {
    return ChatsState(
      chatList: chats ?? this.chatList,
    );
  }

}

class ChatService extends StateNotifier<ChatsState> {
  final WebSocketService _webSocket;
  final KeyService _keyService;
  final AuthService _authService;

  Ref _ref;

  ChatService(this._webSocket, this._keyService, this._authService, this._ref)
      : super(ChatsState(chatList: [])) {
    startListen();
  }

  List<Chat> get chatList =>
      state.chatList;

  void startListen() {
    _webSocket.chatsMessages.listen((message) async {
      switch (message.type) {
        case ("authenticate"):
          {
            getChatList();
            break;
          }
        case ("chat_create"):
          {
            addUpdate(await receiveChat(jsonDecode(message.payload["chat"])));
            break;
          }
        case ("chat_delete"):
          {
            remove((await receiveChat(jsonDecode(message.payload["chat"]))).name);
            break;
          }
      }
    });
  }

  void remove(String chatName) {
    final newList = List<Chat>.from(chatList);

    newList.removeWhere((chat) =>
        chat.participants.any((u) => u.username == chatName)
    );

    state = state.copyWith(chats: newList);
  }

  void addUpdate(Chat chat) {
    final newList = List<Chat>.from(chatList);
    final index = newList.indexWhere((c) => c.id == chat.id);

    if (index >= 0) {
      newList[index] = chat;
    } else {
      newList.add(chat);
    }
    state = state.copyWith(chats: newList);
  }


  void getChatList() async {
    MessagePacket message = MessagePacket(type: "chat_list", payload: {});
    MessagePacket request = await _webSocket.sendRequest(message);

    print(request);


    final List<Map<String, dynamic>> chatList =
    (request.payload['chats'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    print("chatList: $chatList");


    for (var c in chatList) {
      addUpdate(await receiveChat(c));
    }
  }

  Future<Chat> getChatByName(String username) async {
    MessagePacket message = MessagePacket(
        type: "chat_get", payload: {"participant_username": username});
    MessagePacket request = await _webSocket.sendRequest(message);

    Chat chat = await receiveChat(jsonDecode(request.payload["chat"]));

    addUpdate(chat);
    return chat;
  }

  Future<Chat> getChatById(int id) async {
    MessagePacket message = MessagePacket(
        type: "chat_get", payload: {"id": id});
    MessagePacket request = await _webSocket.sendRequest(message);

    Chat chat = await receiveChat(jsonDecode(request.payload["chat"]));

    addUpdate(chat);
    return chat;
  }

  void createChat(String username) async {
    MapEntry<User, String> user = await _webSocket.getUserByUsername(username);

    final SecretKey secretKey = _keyService.decodeAes(
        await _keyService.generateAes());

    String toEncryptKey = await _keyService.encryptAesWithX25519(
        user.value, secretKey);
    String fromEncryptKey = await _keyService.encryptAesWithX25519(
        _keyService.profiles.entries.toList()[_ref.read(
            selectedProfileProvider)].
        value.x25519PublicKeyBase64(), secretKey);

    MessagePacket message = MessagePacket(type: "chat_create", payload: {
      "username": username,
      "toEncryptedKey": toEncryptKey,
      "fromEncryptedKey": fromEncryptKey,
    });

    MessagePacket request = await _webSocket.sendRequest(message);
    addUpdate(await receiveChat(jsonDecode(request.payload["chat"])));
  }


  Future<Chat> receiveChat(Map<String, dynamic> chatMap) async {
    final int id = chatMap['id'];
    final List<dynamic> rawParticipants =
        chatMap['participantsWithKeys'] ??
            chatMap['participants'] ??
            [];

    final List<Map<String, dynamic>> participantsJson =
    rawParticipants.cast<Map<String, dynamic>>();

    print("participantsJson: $participantsJson");

    final List<String> participantsNames = [];

    for (final Map<String, dynamic> user in participantsJson) {
      final String username = user['username'] as String;

      participantsNames.add(username);
    }

    String participant = participantsNames.firstWhere((d) =>
    d != _authService.currentUser!.username);

    final List<User> participants = [];

    for (var username in participantsNames){
      participants.add((await _webSocket.getUserByUsername(username)).key);
    }

    Chat chat = Chat(id: id, name: participant, participants: participants);
    chat.chatKey = await _keyService.decryptAesWithX25519(
        storedString: chatMap["chatKey"],
        keyBytes: _keyService.profiles.entries.toList()[_ref.read(selectedProfileProvider)].value.privateKeyX!);
    print(await chat.chatKey!.extractBytes());
    print("added $chat");
    return chat;
  }
}