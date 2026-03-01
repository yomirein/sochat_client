import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';

class UserInCall extends ConsumerWidget  {

  int userId;

  UserInCall({
    super.key, required this.userId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 293,
      height: 214,
      child: Container(
        decoration: BoxDecoration(
            color: context.colors.foreground,
          border: Border.all(),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: CircleAvatar(
            radius: 40,
            backgroundColor: context.colors.primary,
            child: Text(userId.toString(), style: Theme.of(context).textTheme.bodyLarge,),
          ),
        ),

      ),
    );
  }
}