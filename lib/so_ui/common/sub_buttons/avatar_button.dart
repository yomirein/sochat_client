import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sochat_client/context/menus.dart';
import 'package:sochat_client/context/context_menu.dart';
import 'package:sochat_client/context/context_menu_button.dart';
import 'package:sochat_client/modules/users/user.dart';

class AvatarButton extends ConsumerWidget  {

  User user;

  AvatarButton({
    super.key, required this.user
  });

  final GlobalKey _buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 40,
      height: 30,

      child: ElevatedButton(
        key: _buttonKey,
        onPressed: () {
          final RenderBox box =
          _buttonKey.currentContext!.findRenderObject() as RenderBox;
          Offset globalPosition = box.localToGlobal(Offset.zero);
          final Size size = box.size;

          final Offset menuPosition = Offset(
            globalPosition.dx + size.width + 5 ,
            globalPosition.dy + size.height + 11,
          );

          List<ContextMenuButton> menuItems = Menus.avatarContext(context, ref, user);
          showContextMenu(context, menuPosition, items: menuItems, ref);

        },
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          shape: CircleBorder(),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -10,
              bottom: -10,
              child: CircleAvatar(
                radius: 20,
                child: Text((user.nickname ?? " ")[0]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}