import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';

class BasePanel extends ConsumerWidget {

  final Widget child;
  final double borderRadius;
  final Color? backgroundColor;
  final int flex;
  final EdgeInsets? padding;
  final Color? borderColor;

  const BasePanel({super.key,
    required this.child,
    this.flex = 1,
    this.backgroundColor,
    this.padding,
    this.borderRadius = 10.0,
    this.borderColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: padding,
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor ?? context.colors.outline,
              width: 1.0,
            ),
            color: backgroundColor ?? context.colors.foreground,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: child
      ),
    );
  }
}