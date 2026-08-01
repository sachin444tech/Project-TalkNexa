import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

class TalkNexaApp extends StatelessWidget {
  const TalkNexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'TalkNexa',

      theme: AppTheme.lightTheme,

      home: const Scaffold(
        body: Center(
          child: Text(
            'TalkNexa',
          ),
        ),
      ),
    );
  }
}