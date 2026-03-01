import 'dart:ui';

extension HexColor on String {
  Color toColor() {
    String hex = this.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse(hex, radix: 16));
  }
}