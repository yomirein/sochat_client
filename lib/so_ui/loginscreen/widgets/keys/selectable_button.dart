import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/modules/keys/key_service.dart';
import 'package:sochat_client/so_ui/common/input.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/search/search_list.dart';
import 'package:sochat_client/context_menu/context_window.dart';
import 'package:sochat_client/context_menu/context_menu.dart';
import 'package:sochat_client/context_menu/context_menu_button.dart';

class SelectableButton extends ConsumerStatefulWidget {

  SelectableButton(this.text, this.secondaryText,
      {super.key, required this.size, this.onPressed,
        this.onSecondaryTap, required this.isSelected, required this.menuItems});

  final String text;
  final String secondaryText;
  double size;
  final VoidCallback? onPressed;
  final void Function(TapDownDetails)? onSecondaryTap;

  List<ContextMenuButton> menuItems;

  bool isSelected = false;
  bool isHovered = false;

  final GlobalKey _buttonKey = GlobalKey();

  @override
  ConsumerState<SelectableButton> createState() => _SelectableButtonState();

}
class _SelectableButtonState extends ConsumerState<SelectableButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.isSelected ? context.colors.positive : context.colors.foreground,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),

        onSecondaryTapDown: widget.onSecondaryTap,


        onHover: (hovering) {
          setState(() {
            isHovered = hovering;
          });

        },

        onTap: widget.onPressed,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.colors.outline,
                width: 1,
              ),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.centerLeft,
          child: Row(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.isSelected ? Text(widget.text, style: TextStyle(color: Colors.white),)
              : Text(widget.text, style: TextStyle(color: context.colors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  textAlign: TextAlign.right),

              Expanded(
                child: widget.isSelected ? Text(
                  widget.secondaryText,
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  textAlign: TextAlign.right,)
                    : Text(
                  widget.secondaryText,
                  style: TextStyle(color: context.colors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  textAlign: TextAlign.right,
                ),
              ),
              Stack(
                children: [
                  IgnorePointer(
                    ignoring: false,
                    child: isHovered ? Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        key: widget._buttonKey,
                        onTap: () {
                          final RenderBox box =
                          widget._buttonKey.currentContext!.findRenderObject() as RenderBox;
                          Offset globalPosition = box.localToGlobal(Offset.zero);
                          final Size size = box.size;

                          final Offset menuPosition = Offset(
                            globalPosition.dx + size.width/22 + 5 ,
                            globalPosition.dy + size.height + 11,
                          );

                          showContextMenu(context, menuPosition, items: widget.menuItems, ref);
                        },
                        child: widget.isSelected ? Icon(Icons.more_vert, color: Colors.white.withOpacity(0.5),)
                            : Icon(Icons.more_vert, color: context.colors.textSecondary,),
                      ),
                    ) : SizedBox(width: 24,) ,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}