import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contextManagerProvider = Provider<ContextManager>((ref) {
  return ContextManager();
});


class ContextManager {

  OverlayEntry? currentMenu;
  OverlayEntry? currentWindow;

  void showMenu(OverlayState overlay, OverlayEntry entry) {
    hideMenu();

    currentMenu = entry;

    if (currentWindow != null) {
      overlay.insert(entry, above: currentWindow!);
    } else {
      overlay.insert(entry);
    }
  }

  void showWindow(OverlayState overlay, OverlayEntry entry) {
    hideWindow();

    currentWindow = entry;

    overlay.insert(entry);
  }

  void hideMenu() {
    currentMenu?.remove();
    currentMenu = null;
  }

  void hideWindow() {
    currentWindow?.remove();
    currentWindow = null;
  }
}