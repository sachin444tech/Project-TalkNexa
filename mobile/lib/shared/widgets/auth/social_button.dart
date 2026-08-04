import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {

  final IconData icon;

  final String title;

  final VoidCallback onPressed;

  const SocialButton({

    super.key,

    required this.icon,

    required this.title,

    required this.onPressed,

  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      width: double.infinity,

      height: 58,

      child: OutlinedButton.icon(

        onPressed: onPressed,

        icon: Icon(icon),

        label: Text(title),

      ),

    );

  }

}