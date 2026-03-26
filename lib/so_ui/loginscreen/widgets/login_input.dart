import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';

class LoginInput extends ConsumerWidget {
  final String hintText;
  final TextEditingController inputController;
  final double height;
  final ValueChanged<String>? onChanged;

  const LoginInput({super.key, required this.hintText, required this.inputController, required this.height, this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colors.outline,
          width: 1.0,
        ),
        color: context.colors.foreground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: inputController,
        keyboardType: TextInputType.multiline,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(hintText: hintText,
          hintStyle: Theme.of(context).textTheme.labelMedium,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
        onChanged: onChanged
      ),
    );
  }
}