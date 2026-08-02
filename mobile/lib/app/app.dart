import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import '../features/splash/presentation/splash_screen.dart';

class TalkNexaApp extends StatelessWidget {
  const TalkNexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'TalkNexa',

      theme: AppTheme.lightTheme,

      home: const SplashScreen(),
    );
  }
}