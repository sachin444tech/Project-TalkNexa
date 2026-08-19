import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const heading1 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    letterSpacing: -.8,
  );

  static const heading2 = TextStyle(fontSize: 28, fontWeight: FontWeight.bold);

  static const heading3 = TextStyle(fontSize: 22, fontWeight: FontWeight.w700);

  static const body = TextStyle(fontSize: 16, height: 1.6);

  static const caption = TextStyle(fontSize: 13);
}
