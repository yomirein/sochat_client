import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/modules/common/auth_service.dart';
import 'package:sochat_client/modules/friends/friends_service.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/lists/friend_list/friend_item.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/lists/friend_list/outgoing_friend_item.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/lists/friend_list/outcoming_friend_item.dart';

class FriendList extends ConsumerWidget {
  const FriendList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockedRelativesList = ref.watch(blockedListProvider);
    final friendRelativesList = ref.watch(friendsListProvider);
    final incomingRelativesList = ref.watch(incomingRequestsProvider);
    final outgoingRelativesList = ref.watch(outgoingRequestsProvider);

    final authService = ref.watch(authServiceProvider);

    return Expanded(
      flex: 1,
      child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            border: Border.all(
              color: context.colors.outline,
              width: 1.0,
            ),
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                ...friendRelativesList.map((e) => FriendItem(
                  user: e,
                )),

                ...incomingRelativesList.map((e) => IncomingFriendItem(
                  user: e,
                )),

                ...outgoingRelativesList.map((e) => OutgoingFriendItem(
                  user: e,
                )),

                ...blockedRelativesList.map((e) => FriendItem(
                  user: e,
                )),
              ],
            ),
          )
      ),
    );
  }
}