import 'dart:ui';

import 'package:flutter/material.dart';

class FormInputElements {
  FormInputElements._();

  static TextStyle textStyle = TextStyle(
    fontSize: 20.0,
  );

  static OutlineInputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      25.0,
    ),
  );

  static EdgeInsetsGeometry padding = EdgeInsets.symmetric(
    horizontal: 70.0,
  );
}
