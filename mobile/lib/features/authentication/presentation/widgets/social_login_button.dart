import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {

  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      width: double.infinity,

      height: 56,

      child: OutlinedButton.icon(

        onPressed: onPressed,

        icon: const Icon(Icons.g_mobiledata),

        label: const Text(
          "Continue with Google",
        ),

      ),
    );
  }
}