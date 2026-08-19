import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,

      keyboardType: TextInputType.emailAddress,

      decoration: InputDecoration(
        hintText: "Email",

        prefixIcon: const Icon(Icons.email_outlined),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
