
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mobile/features/ai_practice/domain/models/speaking_session_result.dart';
import 'package:mobile/features/ai_practice/domain/repositories/speaking_session_repository.dart';
import 'package:mobile/features/ai_practice/domain/models/speaking_session_metrics.dart';

class FirestoreSpeakingSessionRepository
    implements SpeakingSessionRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FirestoreSpeakingSessionRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _sessionsCollection() {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw StateError(
        'A signed-in user is required to access speaking history.',
      );
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('speaking_sessions');
  }

  @override
  Future<void> saveSession(SpeakingSessionResult result) async {
    final sessionDocument = _sessionsCollection().doc(result.id);

    await sessionDocument.set({
      'id': result.id,
      'scenario': result.scenario,
      'difficulty': result.difficulty,
      'spokenTurnCount': result.metrics.spokenTurnCount,
      'spokenWordCount': result.metrics.spokenWordCount,
      'correctedTurnCount': result.metrics.correctedTurnCount,
      'durationSeconds': result.metrics.durationSeconds,
      'accuracyScore': result.metrics.accuracyScore,
      'completedAt': Timestamp.fromDate(result.completedAt),
    });
  }

  @override
  Future<List<SpeakingSessionResult>> getSessions() async {
    final snapshot = await _sessionsCollection()
        .orderBy('completedAt', descending: true)
        .get();

    return snapshot.docs.map((document) {
      final data = document.data();

      final metrics = SpeakingSessionMetrics(
        spokenTurnCount: (data['spokenTurnCount'] as num?)?.toInt() ?? 0,
        spokenWordCount: (data['spokenWordCount'] as num?)?.toInt() ?? 0,
        correctedTurnCount:
            (data['correctedTurnCount'] as num?)?.toInt() ?? 0,
        durationSeconds: (data['durationSeconds'] as num?)?.toInt() ?? 0,
      );

      final completedAt = data['completedAt'] as Timestamp?;

      return SpeakingSessionResult(
        id: data['id'] as String? ?? document.id,
        scenario: data['scenario'] as String? ?? '',
        difficulty: data['difficulty'] as String? ?? '',
        metrics: metrics,
        completedAt: completedAt?.toDate() ?? DateTime.now(),
      );
    }).toList();
  }

  @override
  Future<void> clearSessions() async {
    final snapshot = await _sessionsCollection().get();

    // Firestore batches support at most 500 operations.
    // Delete in chunks to avoid exceeding that limit.
    for (var i = 0; i < snapshot.docs.length; i += 500) {
      final batch = _firestore.batch();
      final end = (i + 500 < snapshot.docs.length)
          ? i + 500
          : snapshot.docs.length;

      for (final document in snapshot.docs.sublist(i, end)) {
        batch.delete(document.reference);
      }

      await batch.commit();
    }
  }
}
