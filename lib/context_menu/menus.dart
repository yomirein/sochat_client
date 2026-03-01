import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/modules/chats/chat_service.dart';
import 'package:sochat_client/modules/friends/friendship.dart';
import 'package:sochat_client/modules/keys/key.dart';
import 'package:sochat_client/modules/users/user.dart';
import 'package:sochat_client/context_menu/context_manager.dart';
import 'package:sochat_client/modules/friends/friends_service.dart';
import 'package:sochat_client/modules/keys/key_service.dart';
import 'package:sochat_client/so_ui/common/input.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/search/search_list.dart';
import 'package:sochat_client/context_menu/context_menu_button.dart';
import 'package:sochat_client/context_menu/context_window.dart';
import 'package:sochat_client/so_ui/common/icon_button.dart';
import 'package:sochat_client/so_ui/loginscreen/widgets/settings_button.dart';

class Menus {

  static VoidCallback openSearchWindow(
      BuildContext context,
      WidgetRef ref)
  {
    final friendShipService = ref.read(friendsServiceProvider.notifier);
    final chatService = ref.read(chatsServiceProvider.notifier);

    TextEditingController usernameController = TextEditingController();

    return () {
      showContextWindow(
        context,
        ref,
        height: 500,
        width: 720,
        child: Column(
          spacing: 8,
          children: [
            SoCommonInput(textEditingController: usernameController,),
            SoIconButton(Icons.send, height: 30, width: 30, onPressed: () {
              friendShipService.sendFriendRequest(usernameController.text);
            },),
            SoIconButton(Icons.smart_button, height: 30, width: 30, onPressed: () {
              friendShipService.getRelativesList();
            },),
            SoIconButton(Icons.error, height: 30, width: 30, onPressed: () {
              chatService.getChatList();
            },),
            Expanded(child: SearchList()),
          ],
        ),
      );
    };
  }

  static VoidCallback userProfile(
      BuildContext context,
      WidgetRef ref)
  {
    return () {
      showContextWindow(
        context,
        ref,
        height: 600,
        width: 400,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: context.colors.outline,
                      width: 1,
                    ),
                  ),
                  color: context.colors.foreground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(child: Text("g"), radius: 35),
                    Text("status"),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: context.colors.outline,
                        width: 1,
                      ),
                    ),
                    color: context.colors.foreground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("desc")),
                ),
              ),
              Expanded(
                child: Column(
                  children: [

                  ],
                )
              ),
            ],
          ),
        ));
    };
  }

  static VoidCallback serverEditorWindow(
      BuildContext context,
      int index,
      WidgetRef ref)
  {
    return () {

      var server = ref.read(keyServiceProvider).servers.entries.toList()[index];

      TextEditingController nameController = TextEditingController();
      TextEditingController ipController = TextEditingController();

      nameController.text = server.key;
      ipController.text = server.value;

      String oldKey = server.key;

      showContextWindow(
        context,
        ref,
        height: 200,

        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SoCommonInput(textEditingController: nameController, decoration: InputDecoration(
              hintText: "Server name",
            ),),
            SoCommonInput(textEditingController: ipController, decoration: InputDecoration(
              hintText: "Server ip",
            ),),
            Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SettingsButton(Icons.check, size: 40,
                  onPressed: () {
                    ref.watch(keyServiceProvider.notifier).updateServerName(oldKey, nameController.text);
                    ref.watch(keyServiceProvider.notifier).updateServerIp(oldKey, ipController.text);

                    ref.read(contextManagerProvider).hide();
                  },),
                SettingsButton(Icons.close, size: 40,
                  onPressed: () {
                    ref.read(contextManagerProvider).hide();
                  },)
              ],
            ),

          ],
        ),
      );
    };
  }

  static VoidCallback addServerEditorWindow(
      BuildContext context,
      WidgetRef ref)
  {
    return () {
      TextEditingController nameController = TextEditingController();
      TextEditingController ipController = TextEditingController();

      showContextWindow(
        context,
        ref,
        height: 200,

        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SoCommonInput(textEditingController: nameController, decoration: InputDecoration(
              hintText: "Server name",
            ),),
            SoCommonInput(textEditingController: ipController, decoration: InputDecoration(
              hintText: "Server ip",
            ),),
            Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SettingsButton(Icons.check, size: 40,
                  onPressed: () {
                    ref.watch(keyServiceProvider.notifier).addServer(nameController.text, ipController.text);
                    ref.read(contextManagerProvider).hide();
                  },),
                SettingsButton(Icons.close, size: 40,
                  onPressed: () {
                    ref.read(contextManagerProvider).hide();
                  },)
              ],
            ),

          ],
        ),
      );
    };
  }

  static VoidCallback keyEditorWindow(
      BuildContext context,
      int index,
      WidgetRef ref)
  {
    return () {

      var profile = ref.read(keyServiceProvider).profiles.entries.toList()[index];
      TextEditingController nameController = TextEditingController();
      nameController.text = profile.key;

      String oldKey = profile.key;

      showContextWindow(
        context,
        ref,
        height: 200,

        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SoCommonInput(textEditingController: nameController, decoration: InputDecoration(
              hintText: "Server name",
            ),),
            Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SettingsButton(Icons.check, size: 40,
                  onPressed: () {
                    ref.watch(keyServiceProvider.notifier).updateProfileName(oldKey, nameController.text);

                    ref.read(contextManagerProvider).hide();
                  },),
                SettingsButton(Icons.close, size: 40,
                  onPressed: () {
                    ref.read(contextManagerProvider).hide();
                  },)
              ],
            ),

          ],
        ),
      );
    };
  }


  static List<ContextMenuButton> userContext(
      BuildContext context,
      WidgetRef ref,
      String nickname, String description) {
    return [
      ContextMenuButton(text: nickname,
        leading: CircleAvatar(radius: 20, child: Text(nickname[0])), onTap: () {} ,
        description: description,),
      ContextMenuButton(text: "Pin",
          leading: Icon(Icons.push_pin), onTap: () {}),
      ContextMenuButton(text: "Mark read",
          leading: Icon(Icons.mark_chat_read), onTap: () {}),
      ContextMenuButton(text: "Delete chat",
          leading: Icon(Icons.delete_forever), onTap: () {}),
      ContextMenuButton(text: "Block",
          leading: Icon(Icons.block), onTap: () {}),
    ];
  }

  static List<ContextMenuButton> friendContext(
      BuildContext context,
      WidgetRef ref,
      String nickname, String description) {
    final friendshipService = ref.read(friendsServiceProvider.notifier);
    final chatService = ref.read(chatsServiceProvider.notifier);

    List<ContextMenuButton> items = [];

    items.add(ContextMenuButton(text: nickname,
      leading: CircleAvatar(radius: 20, child: Text(nickname[0])), onTap: () {} ,
      description: description));

    FriendshipStatus status = friendshipService.friendships[nickname]!.status;

    if (status == FriendshipStatus.ACCEPTED){
      items.add(ContextMenuButton(text: "Remove friend",
          leading: Icon(Icons.face_retouching_natural_sharp),
          onTap: () { friendshipService.removeFriend(nickname);}));
      items.add(ContextMenuButton(text: "Create chat",
          leading: Icon(Icons.face_retouching_natural_sharp),
          onTap: () { chatService.createChat(nickname);}));

      items.add(ContextMenuButton(text: "Block",
          leading: Icon(Icons.block),
          onTap: () { friendshipService.blockUser(nickname);}));
    }
    else if (status == FriendshipStatus.PENDING){
      items.add(ContextMenuButton(text: "Decline request",
          leading: Icon(Icons.face_retouching_natural_sharp),
          onTap: () { friendshipService.removeFriend(nickname);}));

      items.add(ContextMenuButton(text: "Block",
          leading: Icon(Icons.block),
          onTap: () { friendshipService.blockUser(nickname);}));
    }

    else if (status == FriendshipStatus.BLOCKED){
      items.add(ContextMenuButton(text: "Unblock",
          leading: Icon(Icons.face_retouching_natural_sharp),
          onTap: () { friendshipService.blockUser(nickname);}));
    }


    return items;
  }

  static List<ContextMenuButton> avatarContext(
      BuildContext context,
      WidgetRef ref, User user) {
    return [
      ContextMenuButton(
        text: user.username,
        leading: CircleAvatar(radius: 20, child: Text(user.username[0])),
        onTap: () {},
        description: "No description",
      ),
      ContextMenuButton(
        text: "Log-out",
        leading: Icon(Icons.logout),
        onTap: () {},
      ),
    ];
  }


  static List<ContextMenuButton> keysListContext(
      BuildContext context,
      int index,
      WidgetRef ref,
      MapEntry<String, KeyP> profile) {
    return [
      ContextMenuButton(
        text: "Edit name",
        leading: Icon(Icons.edit),
        onTap: Menus.keyEditorWindow(context, index, ref)
      ),
      ContextMenuButton(
          text: "Copy JSON",
          leading: Icon(Icons.copy),
          onTap: Menus.keyEditorWindow(context, index, ref)
      ),
      ContextMenuButton(
        text: "Delete",
        leading: Icon(Icons.delete_forever),
        color: context.colors.critical,
        onTap: () {
          ref.read(keyServiceProvider.notifier).removeProfile(profile.key);
        },
      ),
    ];
  }

  static List<ContextMenuButton> serversListContext(
      BuildContext context,
      int index,
      WidgetRef ref,
      MapEntry<String, String> server) {
    return [
      ContextMenuButton(
        text: "Edit",
        leading: Icon(Icons.edit),
        onTap: Menus.serverEditorWindow(context, index, ref),
      ),
      ContextMenuButton(
        text: "Delete",
        leading: Icon(Icons.delete_forever),
        color: context.colors.critical,
        onTap: () {
          ref.read(keyServiceProvider.notifier).removeServer(server.key);
        },
      ),
    ];
  }
}