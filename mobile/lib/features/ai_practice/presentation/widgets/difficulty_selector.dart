import 'package:flutter/material.dart';


import 'package:mobile/app/theme/app_colors.dart';


class DifficultySelector extends StatelessWidget {
  final String selectedDifficulty;
  final ValueChanged<String> onChanged;

  const DifficultySelector({
    super.key,
    required this.selectedDifficulty,
    required this.onChanged,
  });

  static const difficulties = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: difficulties.map((difficulty) {
        final selected =
            difficulty == selectedDifficulty;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: difficulty == difficulties.last
                  ? 0
                  : 8,
            ),
            child: GestureDetector(
              onTap: () => onChanged(difficulty),
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 200,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : Colors.black.withValues(
                            alpha: 0.06,
                          ),
                  ),
                ),
                child: Text(
                  difficulty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}