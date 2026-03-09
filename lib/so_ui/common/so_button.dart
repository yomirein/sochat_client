import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';

class SoButton extends ConsumerWidget {

  SoButton({super.key, required this.child, required this.height, required this.width, this.onPressed, this.color});
  final Widget child;
  double height;
  double width;
  final VoidCallback? onPressed;

  Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    color ??= context.colors.foreground;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(10),
        color: color,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          child: child,
        ),
      ),
    );
  }
}