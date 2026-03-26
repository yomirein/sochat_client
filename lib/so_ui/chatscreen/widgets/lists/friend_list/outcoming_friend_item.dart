import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/modules/friends/friends_service.dart';
import 'package:sochat_client/modules/users/user.dart';
import 'package:sochat_client/so_ui/common/so_button.dart';

import 'friend_item.dart';


class IncomingFriendItem extends ConsumerWidget {
  const IncomingFriendItem({
    super.key,
    required this.user,
    this.description = "",
  });

  final User user;
  final String description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendService = ref.read(friendsServiceProvider.notifier);

    return FriendItem(
      user: user,
      description: description,
      trailing: Row(
        children: [
          SoButton(
            height: 30,
            width: 30,
            onPressed: () {
              friendService.acceptFriendRequest(user.username);
            },
            child: Icon(Icons.check, color: context.colors.textPrimary, size: 25),
          ),
          const SizedBox(width: 10),
          SoButton(
            height: 30,
            width: 30,
            onPressed: () {
              friendService.declineFriendRequest(user.username);
            },
            child: Icon(Icons.close, color: context.colors.textPrimary, size: 25),
          ),
        ],
      ),
    );
  }
}