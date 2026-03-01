

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/hex_color.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/context_menu/context_manager.dart';

import 'context_menu_button.dart';


void showContextMenu(
    BuildContext context,
    Offset position,
    WidgetRef ref, {
      required List<ContextMenuButton> items,
    }) {

  final contextService = ref.read(contextManagerProvider);

  items.forEach((i) {
    i.removeAction = () => contextService.hide();
  });

  final screenSize = MediaQuery.of(context).size;

  double dx = position.dx;
  double dy = position.dy;

  const double edgePadding = 10;

  int menuWidth = 230;
  int menuHeight = items.length * 44;

  if (dx + menuWidth > screenSize.width - edgePadding) {
    dx = position.dx - menuWidth;
    if (dx < edgePadding) dx = edgePadding;
  }

  if (dy + menuHeight > screenSize.height - edgePadding) {
    dy = position.dy - menuHeight;
    if (dy < edgePadding) dy = edgePadding;
  }

  final overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => contextService.hide(),
            ),
          ),
          Positioned(
            left: dx,
            top: dy,
            child: Material(
              borderRadius: BorderRadius.circular(10),
              color: context.colors.foreground,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.colors.outline,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  spacing: 0,
                  children: items,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  contextService.show(context, overlayEntry);
}