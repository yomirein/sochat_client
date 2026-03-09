import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';

class SoButton extends ConsumerWidget {
  const SoButton({
    super.key,
    required this.child,
    required this.height,
    required this.width,
    this.onPressed,
    this.color,
  });

  final Widget child;
  final double height;
  final double width;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonColor = color ?? context.colors.foreground;

    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
        ),
        child: child,
      ),
    );
  }
}