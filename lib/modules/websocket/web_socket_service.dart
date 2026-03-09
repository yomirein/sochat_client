import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/modules/websocket/message_packet.dart';
import 'package:sochat_client/modules/users/user.dart';
import 'package:sochat_client/modules/friends/friends_service.dart';
import 'package:sochat_client/modules/keys/key_service.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:io';

final webSocketProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService();

  ref.onDispose(() {
    service.channel?.sink.close();
  });
  return service;
});


class WebSocketService{
  WebSocketChannel? channel;

  final _friendsController = StreamController<MessagePacket>.broadcast();
  Stream<MessagePacket> get friendsMessages => _friendsController.stream;

  final _chatsController = StreamController<MessagePacket>.broadcast();
  Stream<MessagePacket> get chatsMessages => _chatsController.stream;

  final _usersController = StreamController<MessagePacket>.broadcast();
  Stream<MessagePacket> get usersMessages => _usersController.stream;

  final _messagesController = StreamController<MessagePacket>.broadcast();
  Stream<MessagePacket> get messagesMessages => _messagesController.stream;

  final _pendingRequests = <String, Completer>{};


  Future<void> connect() async {
    channel = WebSocketChannel.connect(
        Uri.parse('ws://localhost:8081/ws')
    );

    await channel!.ready;
    _startPing();
    channel!.stream.listen((message) {
      MessagePacket messagg = MessagePacket.fromJson(jsonDecode(message));

      if (messagg.type != "pong") print("WS RAW MESSAGE: $message");

      final requestId = messagg.payload["requestId"];
      if (requestId != null && _pendingRequests.containsKey(requestId)) {
        _pendingRequests[requestId]!.complete(messagg);
        _pendingRequests.remove(requestId);
      }

      switch (messagg.type) {
        case "pong":
          {
            print("pong");
            break;
          }

        case "friend_request":
        case "friend_accept":
        case "friend_decline":
        case "friend_remove":
        case "block": {
          _friendsController.add(messagg);
          break;
        }
        case "authenticate":
        case "chat_create":
        case "chat_delete": {
          _chatsController.add(messagg);
          break;
        }
        case "message_send":
        case "message_edit":
        case "message_delete":{
          _messagesController.add(messagg);
          break;
      }
        default:
          print("Необработанный тип: ${messagg.type}");
      }
    });
  }



  void addToSink(WebSocketChannel? channel, Map<String, dynamic> message) {
    if (channel == null) {
      print('WS NOT CONNECTED — signal DROPPED');
      return;
    }

    print(message);
    channel.sink.add(jsonEncode(message));
  }

  Future<dynamic> sendRequest(MessagePacket messagePacket) {
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();
    final completer = Completer();
    _pendingRequests[requestId] = completer;

    messagePacket.payload["requestId"] = requestId;

    addToSink(channel!, messagePacket.toJson());
    return completer.future.timeout(
      Duration(minutes: 5),
      onTimeout: () {
        _pendingRequests.remove(requestId);
        throw TimeoutException("Request $requestId timed out after 5 minutes");
      },
    );
  }


  void _startPing(){
    if (channel == null) return;
    Timer.periodic(
      const Duration(seconds: 10),
          (_) {
            MessagePacket message = MessagePacket(type: "ping", payload: {});
        addToSink(channel!, message.toJson());
      },
    );
  }

  void authenticate(String token) async {
    MessagePacket message = MessagePacket(type: "authenticate", payload: {
      "token": token,
    });
    MessagePacket request = await sendRequest(message);
    _friendsController.add(request);
    }

}