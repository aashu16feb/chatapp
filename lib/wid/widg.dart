import 'package:flutter/material.dart';

PreferredSizeWidget appBarMAin(BuildContext context) {
  return AppBar(
    title: Image.asset("assets/images/logof.png", height: 30),
  );
}

InputDecoration textfieldDecor(String hintText) {
  return InputDecoration(hintText: hintText, hintStyle: TextStyle(color: Colors.white54), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle texts(Color color) {
  return TextStyle(
    color: color,
  );
}

TextStyle textb() {
  return TextStyle(
    color: Colors.white,
    fontSize: 18,
  );
}
