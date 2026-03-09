import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:sochat_client/modules/users/user.dart';
import 'package:sochat_client/modules/websocket/message_packet.dart';
import 'package:sochat_client/modules/websocket/web_socket_service.dart';

import '../common/auth_service.dart';
import '../keys/key_service.dart';

final userServiceProvider = StateNotifierProvider<UserService, UserState>(
      (ref) => UserService(ref.read(webSocketProvider), ref.read(keyServiceProvider.notifier), ref.read(authServiceProvider)),);


class UserState {

/*ChatsState copyWith({

    Map<String, Friendship>? friendships,
  }) {
    return FriendsState(
      friendships: friendships ?? this.friendships,
    );
  }

    */
}

class UserService extends StateNotifier<UserState> {
  final WebSocketService _webSocket;
  final KeyService _keyService;
  final AuthService _authService;

  UserService(this._webSocket, this._keyService, this._authService)
      : super(UserState()) {
    startListen();
  }

  void startListen() {
    _webSocket.usersMessages.listen((message) {

    });
  }


  Future<MapEntry<User, String>> getUserByUsername(String username) async {
    MessagePacket message = MessagePacket(type: "user_get", payload: {
      "username": username,
    });
    MessagePacket request = await _webSocket.sendRequest(message);
    final userMap = jsonDecode(request.payload["user"]) as Map<String, dynamic>;
    User user = User.fromJson(userMap);
    String pbKey = userMap["x25519PublicKey"];

    return MapEntry(user, pbKey);
  }
  Future<MapEntry<User, String>> getUserById(int id) async {
    MessagePacket message = MessagePacket(type: "user_get", payload: {
      "id": id,
    });
    MessagePacket request = await _webSocket.sendRequest(message);
    final userMap = jsonDecode(request.payload["user"]) as Map<String, dynamic>;
    User user = User.fromJson(userMap);
    String pbKey = userMap["x25519PublicKey"];

    return MapEntry(user, pbKey);
  }
}
