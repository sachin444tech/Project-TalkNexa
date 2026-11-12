
import 'package:flutter/material.dart';

import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';

class ScenarioProgressCard extends StatelessWidget {
  final List<SpeakingSessionResult> sessions;

  const ScenarioProgressCard({
    super.key,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    final scenarioGroups = <String, List<SpeakingSessionResult>>{};

    for (final session in sessions) {
      scenarioGroups.putIfAbsent(
        session.scenario,
        () => [],
      );

      scenarioGroups[session.scenario]!.add(session);
    }

    final scenarios = scenarioGroups.entries.toList()
      ..sort(
        (a, b) => b.value.length.compareTo(a.value.length),
      );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scenario-wise Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'See how you perform across different situations.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),

            if (scenarios.isEmpty)
              const Text('Complete a speaking session to see your progress.'),

            ...scenarios.map((entry) {
              final scenarioSessions = entry.value;

              final totalWords = scenarioSessions.fold<int>(
                0,
                (total, session) =>
                    total + session.metrics.spokenWordCount,
              );

              final averageScore = scenarioSessions.fold<double>(
                    0,
                    (total, session) =>
                        total + session.metrics.practiceScore,
                  ) /
                  scenarioSessions.length;

              final progress = (averageScore / 100).clamp(0.0, 1.0);

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          '${averageScore.round()}/100',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainerHighest,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${scenarioSessions.length} sessions  •  $totalWords words spoken',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
