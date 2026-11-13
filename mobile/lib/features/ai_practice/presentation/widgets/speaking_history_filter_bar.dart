
import 'package:flutter/material.dart';

import 'package:mobile/features/ai_practice/domain/models/spealking_history_filter.dart';

class SpeakingHistoryFilterBar extends StatelessWidget {
  final SpeakingHistoryFilter selectedFilter;
  final ValueChanged<SpeakingHistoryFilter> onFilterChanged;

  const SpeakingHistoryFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: SpeakingHistoryFilter.values.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = SpeakingHistoryFilter.values[index];
          final isSelected = filter == selectedFilter;

          return ChoiceChip(
            label: Text(filter.label),
            selected: isSelected,
            onSelected: (_) => onFilterChanged(filter),
            selectedColor: Theme.of(context).colorScheme.primary,
            labelStyle: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: isSelected
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
            side: BorderSide(
              color: isSelected
                  ? Colors.transparent
                  : Theme.of(context).dividerColor,
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}
