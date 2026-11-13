import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';
import 'package:mobile/features/ai_practice/domain/models/spealking_history_filter.dart';

class SpeakingHistoryFilterService {
  const SpeakingHistoryFilterService();

  List<SpeakingSessionResult> filterSessions({
    required List<SpeakingSessionResult> sessions,
    required SpeakingHistoryFilter filter,
  }) {
    final selectedScenario = filter.scenario;

    if (selectedScenario == null) {
      return sessions;
    }

    return sessions.where((session) {
      return session.scenario.toLowerCase() ==
          selectedScenario.toLowerCase();
    }).toList();
  }
}
