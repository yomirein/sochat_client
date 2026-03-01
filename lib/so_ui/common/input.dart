import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/hex_color.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';

class SoCommonInput extends ConsumerWidget {

  TextStyle? textStyle;
  final InputDecoration? decoration;

  Border? border;
  Color? color;
  BorderRadius? borderRadius;

  TextEditingController? textEditingController;

  SoCommonInput({super.key, this.textStyle, this.decoration, this.border, this.color, this.borderRadius, this.textEditingController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDecoration = InputDecoration(
      hintText: "What are you looking for?",
      hintStyle: Theme.of(context).textTheme.labelMedium,
      border: const OutlineInputBorder(borderSide: BorderSide.none),
    );

    return Container(
        decoration: BoxDecoration(
          border: border ?? Border(
            top: BorderSide.none,
            left: BorderSide.none,
            right: BorderSide.none,
            bottom: BorderSide(
              color: context.colors.outline,
              width: 1,
            ),
          ),
          color: color ?? context.colors.foreground,
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        child: TextField(
            controller: textEditingController,
            keyboardType: TextInputType.multiline,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: decoration?.copyWith(
              hintText: decoration?.hintText ?? defaultDecoration.hintText,
              hintStyle: decoration?.hintStyle ?? defaultDecoration.hintStyle,
              border: decoration?.border ?? defaultDecoration.border,
              prefixIcon: decoration?.prefixIcon ?? defaultDecoration.prefixIcon,
              suffixIcon: decoration?.suffixIcon ?? defaultDecoration.suffixIcon,
              contentPadding: decoration?.contentPadding ?? defaultDecoration.contentPadding,
            ) ??
                defaultDecoration
        )
    );
  }
}