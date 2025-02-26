import 'dart:ui';

class MyColors {
  static final blackColor = HexColor('#0E0E0E');
  static final whiteColor = HexColor('#ffffff');
  static final purpleColor = HexColor('#471AA0');
  static final purpleColor2 = HexColor('c256ec');
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
