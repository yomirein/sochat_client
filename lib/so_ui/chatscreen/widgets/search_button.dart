import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';

class SearchButton extends ConsumerWidget {
  final VoidCallback? onPressed;

  const SearchButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide.none,
          left: BorderSide.none,
          right: BorderSide.none,
          bottom: BorderSide(
            color: context.colors.outline,
            width: 1,
          ),
        ),
        color: context.colors.foreground,
        borderRadius: BorderRadius.circular(10),
      ),
        child: Material(
          color: context.colors.foreground,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onPressed,
              child:
              SizedBox(height: 30,
                  child: Center(
                      child: Text("Search", textAlign: .center)
                  )
              )
          ),
        ),
    );
  }
}