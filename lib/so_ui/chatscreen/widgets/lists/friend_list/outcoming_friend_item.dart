import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/context_menu/menus.dart';
import 'package:sochat_client/context_menu/context_manager.dart';
import 'package:sochat_client/context_menu/context_menu.dart';
import 'package:sochat_client/extenstions/hex_color.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/context_menu/context_menu_button.dart';
import 'package:sochat_client/modules/friends/friends_service.dart';
import 'package:sochat_client/so_ui/common/icon_button.dart';

import 'friend_item.dart';


class IncomingFriendItem extends ConsumerWidget {
  const IncomingFriendItem({
    super.key,
    required this.nickname,
    this.description = "",
  });

  final String nickname;
  final String description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendService = ref.read(friendsServiceProvider.notifier);

    return FriendItem(
      nickname: nickname,
      description: description,
      trailing: Row(
        children: [
          SoIconButton(
            Icons.check,
            height: 30,
            width: 30,
            onPressed: () {
              friendService.acceptFriendRequest(nickname);
            },
          ),
          const SizedBox(width: 10),
          SoIconButton(
            Icons.close,
            height: 30,
            width: 30,
            onPressed: () {
              friendService.declineFriendRequest(nickname);
            },
          ),
        ],
      ),
    );
  }
}