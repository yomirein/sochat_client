import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sochat_client/modules/keys/key.dart';
import 'package:sochat_client/modules/websocket/message_packet.dart';
import 'package:sochat_client/modules/users/user.dart';
import 'package:sochat_client/modules/websocket/web_socket_service.dart';
import 'package:sochat_client/so_ui/chatscreen/chat_screen.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthService {

  User? currentUser;
  String? token;

  Future<void> login(
      BuildContext context,
      String username,
      KeyP keyPair,
      String ip, WidgetRef ref) async {

    var url = Uri.parse((ip + '/auth/login?username=${username}').toString());
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print("hello?");
    print(response.body);

    var mapResponse = jsonDecode(response.body) as Map<String, dynamic>;
    var payload = mapResponse["payload"] as Map<String, dynamic>;
    if (payload["success"] == true) {
      await verify(context, username, keyPair, payload["challenge"].toString(), ip, ref);
    } else {
      print("пупупу");
    }
  }

  Future<void> verify(BuildContext context,
      String username, KeyP keyPair,
      String challenge, ip, WidgetRef ref) async {


    var signature = await keyPair.sign(utf8.encode(challenge));
    var signatureBase64 = base64Encode(signature);

    MessagePacket packet = MessagePacketBuilder()
        .type("verify")
        .put("username", username)
        .put("signature", signatureBase64)
        .put("challenge", challenge)
        .build();

    var url = Uri.parse((ip + '/auth/verify').toString());
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(packet.toJson()),
    );

    var mapResponse = jsonDecode(response.body) as Map<String, dynamic>;
    var payload = mapResponse["payload"] as Map<String, dynamic>;

    print('web');
    final webSocketService = ref.watch(webSocketProvider);
    webSocketService.connect();



    print(response.body);

    if (payload["success"] == true) {

      token = payload["token"];
      webSocketService.authenticate(payload["token"]);

      print(payload);
      var user = jsonDecode(payload["user"]) as Map<String, dynamic>;
      currentUser = User(id: user["id"], username: user["username"]);

      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
    } else {
      print(response.body);
    }
  }


  Future<void> register(
      String username,
      KeyP keyPair,
      String ip) async {
    var url = Uri.parse((ip + '/auth/register').toString());


    MessagePacket packet = MessagePacketBuilder()
        .type('register')
        .put('username', username)
        .put('ed25519PublicKey', base64Encode(keyPair.x509ed25519PublicKey()))
        .put('x25519PublicKey', base64Encode(keyPair.x509x25519PublicKey()))
        .build();

    var response = await http.post(
      url,

      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(packet),
    );

    print(response.body);
  }

}