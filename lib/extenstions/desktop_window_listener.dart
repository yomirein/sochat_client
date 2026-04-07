import 'package:window_manager/window_manager.dart';

class DesktopWindowListener extends WindowListener {
  @override
  void onWindowClose() async {
    await windowManager.hide();
  }
}