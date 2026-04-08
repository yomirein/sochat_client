
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/modules/keys/key_service.dart';

final mediaServiceProvider = Provider<MediaService>((ref) {
  final _keyService = ref.read(keyServiceProvider.notifier);
  return MediaService(_keyService);
});

class MediaService {

  final KeyService _keyService;

  MediaService(this._keyService);

  Image decodeImageFromBytes(String base64String) {
    return Image.memory(jsonDecode(base64String));
  }

  void resolveImage(String mediaId){
    
  }

}