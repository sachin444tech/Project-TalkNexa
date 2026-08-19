import 'package:flutter/material.dart';

import 'package:mobile/app/theme/app_colors.dart';

class AiPartnerAvatar extends StatefulWidget {
  const AiPartnerAvatar({super.key});

  @override
  State<AiPartnerAvatar> createState() => _AiPartnerAvatarState();
}

class _AiPartnerAvatarState extends State<AiPartnerAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1.04,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: Container(
        width: 118,
        height: 118,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 35,
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.smart_toy_rounded, color: Colors.white, size: 58),
        ),
      ),
    );
  }
}
