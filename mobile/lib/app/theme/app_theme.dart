import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),

    scaffoldBackgroundColor: AppColors.background,

    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}
