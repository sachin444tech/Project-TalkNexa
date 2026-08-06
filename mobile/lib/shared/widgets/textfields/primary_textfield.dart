import 'package:flutter/material.dart';
import 'package:mobile/app/theme/app_colors.dart';
import 'package:mobile/core/constants/app_radius.dart';


class PrimaryTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscureText;

  const PrimaryTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscureText = false, required TextEditingController controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: AppColors.primary,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppRadius.large,
          ),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}