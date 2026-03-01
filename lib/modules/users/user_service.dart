import 'package:flutter_riverpod/legacy.dart';
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
}
