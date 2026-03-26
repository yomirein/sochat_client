
import 'package:flutter/material.dart';
import 'package:sochat_client/extenstions/hex_color.dart';
import 'package:sochat_client/so_ui/themes/colors.dart';

class DarkTheme {
  static List<ThemeExtension<dynamic>> get extensions => [
    AppColors(
      background: "1F1D1F".toColor(),
      outline: "605B5F".toColor(),
      surface: "323032".toColor(),
      foreground: "423F42".toColor(),
      textPrimary: "FBFFEF".toColor(),
      textSecondary: "CACDC2".toColor(),
      positive: "3BE490".toColor(),
      caution: "E4CB3B".toColor(),
      critical: "E43B57".toColor(),
      primary: "B57DE0".toColor(),
      contrastColor: Colors.white,
    ),
  ];
}