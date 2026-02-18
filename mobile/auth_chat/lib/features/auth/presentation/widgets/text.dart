import 'package:flutter/material.dart';

Widget customText({
  required String text,
  required double size,
  Color color = const Color.fromARGB(255, 78, 76, 76),
  bool isBold = false,
}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: size,
      fontFamily: 'sans-serif',
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: color,
    ),
  );
}
