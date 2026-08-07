import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [

        Icon(
          Icons.chat_bubble_rounded,
          size: 70,
          color: Color(0xff2563EB),
        ),

        SizedBox(height: 18),

        Text(
          "Welcome Back",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 10),

        Text(
          "Continue your English journey",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}