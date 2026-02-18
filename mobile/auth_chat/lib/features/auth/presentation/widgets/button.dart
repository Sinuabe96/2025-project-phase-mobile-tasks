import 'package:flutter/material.dart';

Widget signButton({
  required String buttonTitle,
  required VoidCallback onpressed,
  Color color = Colors.deepPurple,
  double radius = 12.0,
  Color textColor = Colors.white,
}) {
  return SizedBox(
    width: double.infinity,
    height: 40,
    child: ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: Text(buttonTitle, style: TextStyle(color: textColor)),
    ),
  );
}

Widget deleteButton({
  required String buttonTitle,
  required VoidCallback onpressed,
  double radius = 12.0,
  Color textColor = Colors.red,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: const BorderSide(
          // width: 5.0,
          color: Colors.red,
        ),
      ),
      child: Text(buttonTitle, style: TextStyle(color: textColor)),
    ),
  );
}
