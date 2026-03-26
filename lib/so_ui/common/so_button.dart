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
    this.onSecondaryTapDown,
    this.color,
    this.borderColor,
    this.alignment,
  });

  final Widget child;
  final double height;
  final double width;
  final VoidCallback? onPressed;
  final void Function(TapDownDetails)? onSecondaryTapDown;
  final Color? color;
  final Color? borderColor;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: 1,
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: color ?? context.colors.foreground,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          onSecondaryTapDown: onSecondaryTapDown,
          child: Align(
            alignment: alignment ?? Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}
/*
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(2
            alignment: alignment ?? Alignment.center,
            splashFactory: NoSplash.splashFactory,
            backgroundColor: buttonColor,
          ),
          child: child,
        ),
*/