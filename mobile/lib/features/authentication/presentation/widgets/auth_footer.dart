import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        const Text("Don't have an account?"),

        TextButton(onPressed: () {}, child: const Text("Create Account")),
      ],
    );
  }
}
