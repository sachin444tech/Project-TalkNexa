import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,

      obscureText: true,

      decoration: InputDecoration(
        hintText: "Password",

        prefixIcon: const Icon(Icons.lock_outline),

        suffixIcon: const Icon(Icons.visibility_off_outlined),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
