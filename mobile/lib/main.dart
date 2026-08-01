import 'package:flutter/material.dart';

void main() {
  runApp(const TalkNexaApp());
}

class TalkNexaApp extends StatelessWidget {
  const TalkNexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TalkNexa',
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TalkNexa"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Welcome to TalkNexa 🚀\nLet's Speak English!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}