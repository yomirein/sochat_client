import 'package:flutter/material.dart';
import 'package:sochat_client/so_ui/themes/colors.dart';

extension ThemeGetter on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  //AppSizes get sizes => Theme.of(this).extension<AppSizes>()!;
}