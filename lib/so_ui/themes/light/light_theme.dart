
import 'package:flutter/material.dart';
import 'package:sochat_client/extenstions/hex_color.dart';
import 'package:sochat_client/so_ui/themes/colors.dart';

class LightTheme {
  static List<ThemeExtension<dynamic>> get extensions => [
    AppColors(
      background: "DFD9DE".toColor(),
      outline: "E5E2E5".toColor(),
      surface: "EDE9ED".toColor(),
      foreground: "F4F4F4".toColor(),
      textPrimary: "1D1F1F".toColor(),
      textSecondary: "2B2D2D".toColor(),
      positive: "3BE490".toColor(),
      caution: "E4CB3B".toColor(),
      critical: "E43B57".toColor(),
      primary: "B57DE0".toColor(),
      contrastColor: Colors.black,
    ),
  ];
}