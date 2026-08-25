import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static final soft = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 25,
      offset: const Offset(0, 12),
    ),
  ];
}
