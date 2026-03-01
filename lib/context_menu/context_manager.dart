import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final contextManagerProvider = Provider<ContextManager>((ref) {
  return ContextManager();
});


class ContextManager {

  OverlayEntry? currentMenu;

  void updateContextMenu(OverlayEntry? newCurrentMenu) {
    currentMenu = newCurrentMenu;
  }

  OverlayEntry? getContextMenu() {
    return currentMenu;
  }

  void show(BuildContext context, OverlayEntry entry) {
    if (currentMenu != null) {
      hide();
      return;
    }

    currentMenu = entry;
    Overlay.of(context).insert(entry);
  }

  void hide() {
    currentMenu?.remove();
    currentMenu = null;
  }

}