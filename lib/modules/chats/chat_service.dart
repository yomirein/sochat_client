 
import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sochat_client/modules/chats/chat.dart';
import 'package:sochat_client/modules/chats/chat_role.dart';
import 'package:sochat_client/modules/chats/chat_type.dart';
import 'package:sochat_client/modules/chats/sender_key.dart';
import 'package:sochat_client/modules/users/user_service.dart';
import 'package:sochat_client/modules/websocket/message_packet.dart';
import 'package:sochat_client/modules/users/user.dart';
import 'package:sochat_client/modules/websocket/web_socket_service.dart';
import 'package:sochat_client/so_ux/chatscreen/chat_controller.dart';

import '../common/auth_service.dart';
import '../keys/key_service.dart';

final chatsServiceProvider = StateNotifierProvider<ChatService, ChatsState>(
      (ref) => ChatService(ref.read(webSocketProvider), ref.read(keyServiceProvider.notifier), ref.read(authServiceProvider), ref.read(userServiceProvider.notifier), ref),);



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
  final UserService _userService;

  Ref _ref;

  ChatService(this._webSocket, this._keyService, this._authService, this._userService, this._ref)
      : super(ChatsState(chatList: [])) {
    startListen();
  }

  List<Chat> get chatList =>
      state.chatList;

  void startListen() {
    _webSocket.chatsMessages.listen((message) async {
      switch (message.type) {
        case ("authenticate"):
          getChatList();
          break;
        case ("chat_add_participant"):
        case ("chat_create"):
          {
            addUpdate(await receiveChat(jsonDecode(message.payload["chat"])));
            break;
          }
        case ("chat_delete"):
          {
            remove((await receiveChat(jsonDecode(message.payload["chat"]))).title);
            break;
          }
      }
    });
  }

  void remove(String chatName) {
    final newList = List<Chat>.from(chatList);

    newList.removeWhere((chat) => chat.title == chatName);

    _ref.read(selectedChatProvider.notifier).state = null;

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


  Future<void> getChatList() async {
    MessagePacket message = MessagePacket(type: "chat_list", payload: {});
    MessagePacket request = await _webSocket.sendRequest(message);

    print(request);

    final List<Map<String, dynamic>> chatList =
    (jsonDecode(request.payload['chats']) as List)
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

  void createChat(List<int> userIds, ChatType chatType, String? title) async {
    final SecretKey secretKey = _keyService.decodeAes(
        await _keyService.generateAes());

    String fromEncryptKey = await _keyService.encryptAesWithX25519(
        _keyService.profiles.entries.toList()[_ref.read(
            selectedProfileProvider)].
        value.x25519PublicKeyBase64(), secretKey);

    Map<String, String> users = {};

    for (int userId in userIds) {
      MapEntry<User, String> user = await _userService.getUserById(userId);

      users[userId.toString()] = await _keyService.encryptAesWithX25519(
        user.value,
        secretKey,
      );
    }

    MessagePacket message = MessagePacket(type: "chat_create", payload: {
      "title": title,
      "chatType": chatType.name,
      "fromEncryptedKey": fromEncryptKey,
      "users": users
    });

    MessagePacket request = await _webSocket.sendRequest(message);
    addUpdate(await receiveChat(jsonDecode(request.payload["chat"])));
  }

  Future<void> deleteChat(int chatId) async {
    MessagePacket message = MessagePacket(type: "chat_delete", payload: {
      "id": chatId,
    });

    MessagePacket request = await _webSocket.sendRequest(message);
    remove((await receiveChat(jsonDecode(request.payload["chat"]))).title);
  }


  Future<Chat> receiveChat(Map<String, dynamic> chatMap) async {
    Chat chat = Chat(id: chatMap['id'], title: chatMap["title"], type: ChatType.values.byName(chatMap["chatType"]));

    if (chatMap["participants"] != null) {
      List<dynamic> participantsJson = chatMap["participants"];
      for (Map<String, dynamic> participantJson in participantsJson){
        User user = (await _userService.getUserById(participantJson["userId"])).key;
        chat.participants[user] = ChatRole.values.byName(participantJson["chatRole"]);
      }
      print(participantsJson);
    }

    if (chatMap["senderKeys"] != null) {
      List<dynamic> senderKeysJson = chatMap["senderKeys"];
      for (Map<String, dynamic> senderKeyJson in senderKeysJson){
        SenderKey senderKey = SenderKey(keyVersion: senderKeyJson["keyVersion"], key: (await _keyService.decryptAesWithX25519(storedString: senderKeyJson["chatKey"], keyBytes: _keyService.profiles.entries.toList()[_ref.read(selectedProfileProvider)].value.privateKeyX!)));
        chat.chatKeys.add(senderKey);
      }
      print(senderKeysJson);
    }


    return chat;
  }

  Future<void> addParticipant(int userId, Chat chat) async {

    Map<String, String> users = {};
    MapEntry<User, String> user = await _userService.getUserById(userId);

    if (chat.type == ChatType.GROUP_INSECURE) {
      users[userId.toString()] = await _keyService.encryptAesWithX25519(
        user.value,
        chat.chatKeys.last.key,
      );
    }
    else {
      final SecretKey secretKey = _keyService.decodeAes(
          await _keyService.generateAes());

      for (User participant in chat.participants.keys) {

        users[user.key.id.toString()] = await _keyService.encryptAesWithX25519(
          user.value,
          secretKey,
        );

        MapEntry<User, String> participantFull = await _userService.getUserById(participant.id);
        users[participant.id.toString()] = await _keyService.encryptAesWithX25519(
          participantFull.value,
          secretKey,
        );
      }
    }

    MessagePacket message = MessagePacket(type: "chat_add_participant", payload: {
      "userId": userId,
      "chatId": chat.id,
      "users": users
    });

    MessagePacket request = await _webSocket.sendRequest(message);
    Chat receivedChat = await receiveChat(jsonDecode(request.payload["chat"]));

    addUpdate(receivedChat);
  }
}