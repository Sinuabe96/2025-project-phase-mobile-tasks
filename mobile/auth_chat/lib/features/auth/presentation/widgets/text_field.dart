import 'package:flutter/material.dart';

// TextFormField Function
Widget textInput({
  required TextEditingController controller,
  int maxLines = 1,
  String hintText = '',
  TextInputType inputType = TextInputType.text,
  String invalidInputMessege = 'This Field can\'t be empty',
}) {
  return TextFormField(
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hintText,
      enabledBorder: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: const Color.fromARGB(255, 241, 240, 240),
    ),
    controller: controller,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return invalidInputMessege;
      }
      return null;
    },
    keyboardType: inputType,
  );
}
