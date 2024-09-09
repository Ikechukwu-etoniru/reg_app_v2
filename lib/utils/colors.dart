import 'dart:math';

import 'package:flutter/material.dart';

class MyColors {
  static const primayGreen = Color(0xff00401A);
  static const secGreen1 = Color(0xff7DB020);
  static const secGreen2 = Color(0xff618223);
  static const secGreen3 = Color(0xff618C11);
  static const secGreen4 = Color(0xff568203);
  static const greyColor = Color(0xffAEAEB2);
  static const darkgrey = Color(0xff3A3A3A);
  static const altGreen = Color(0xffD3EFA0);
  static const tfGreen = Color(0xffEDF2E3);

  static const bronzeColor = Color(0xff733509);
  static const silverColor = Color(0xff808080);
  static const goldColor = Color(0xffD78F16);
  static const diamondColor = Color(0xff00A3D7);
  static const emeraldColor = Color(0xff107D1B);

  static Color getRandomColor() {
    final random = Random();

    final red = random.nextInt(256);
    final green = random.nextInt(256);
    final blue = random.nextInt(256);

    final randomColor = Color.fromARGB(255, red, green, blue);

    return randomColor;
  }

  static List<Color> barColors = [
    Colors.black,
    Colors.red,
    Colors.blueGrey,
    Colors.teal,
    Colors.purple,
    Colors.pink,
    Colors.lime,
    Colors.orange,
    Colors.indigo,
    Colors.cyan,
    Colors.amber,
    Colors.brown
  ];
}
