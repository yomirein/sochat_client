import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/hex_color.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/context_menu/context_manager.dart';
import 'package:sochat_client/so_ui/common/input.dart';
import 'package:sochat_client/so_ui/chatscreen/widgets/search/search_list.dart';

import 'context_menu_button.dart';


void showContextWindow(
    BuildContext context,
    WidgetRef ref,
    {required Widget child, double height = 700, double width = 466}
    ) {
  final contextService = ref.read(contextManagerProvider);

  final overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => contextService.hide(),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Center(
            child: Material(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: width,
                height: height,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.colors.outline,
                  ),
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: child
              ),
            ),
          ),
        ],
      );
    },
  );
  contextService.hide();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    contextService.show(context, overlayEntry);
  });
}