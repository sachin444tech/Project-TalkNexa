import 'package:flutter/material.dart';

import 'package:mobile/app/theme/app_colors.dart';

class DurationSelector extends StatelessWidget {
  final int selectedDuration;
  final ValueChanged<int> onChanged;

  const DurationSelector({
    super.key,
    required this.selectedDuration,
    required this.onChanged,
  });

  static const durations = [5, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: durations.map((duration) {
        final selected = duration == selectedDuration;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: duration == durations.last ? 0 : 8),
            child: GestureDetector(
              onTap: () => onChanged(duration),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: selected ? AppColors.secondary : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? AppColors.secondary
                        : Colors.black.withValues(alpha: 0.06),
                  ),
                ),
                child: Text(
                  '$duration min',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppColors.textSecondary,
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
