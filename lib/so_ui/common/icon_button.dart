import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';

class SoIconButton extends ConsumerWidget {

  SoIconButton(this.icon, {super.key, required this.height, required this.width, this.onPressed, this.color});
  final IconData icon;
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
          child: Icon(icon, color: context.colors.textPrimary, size: height/1.5),
        ),
      ),
    );
  }
}