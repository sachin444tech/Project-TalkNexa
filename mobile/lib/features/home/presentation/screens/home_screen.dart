
import 'package:flutter/material.dart';

import 'package:mobile/features/ai_practice/presentation/screens/ai_practice_setup_screen.dart';
import 'package:mobile/features/ai_practice/presentation/screens/speaking_history_screen.dart';
import 'package:mobile/features/home/presentation/widgets/achievement_preview.dart';
import 'package:mobile/features/home/presentation/widgets/daily_goal_card.dart';
import 'package:mobile/features/home/presentation/widgets/home_header.dart';
import 'package:mobile/features/home/presentation/widgets/practice_option_card.dart';
import 'package:mobile/features/home/presentation/widgets/progress_preview_card.dart';
import 'package:mobile/features/home/presentation/widgets/speaking_hero_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature is coming soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openSpeakingHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SpeakingHistoryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const HomeHeader(userName: 'TalkNexa Learner'),

                  const SizedBox(height: 28),

                  SpeakingHeroCard(
                    onStartSpeaking: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AiPracticeSetupScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Practice your way',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Choose the experience that fits your goal.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PracticeOptionCard(
                          icon: Icons.smart_toy_rounded,
                          title: 'AI Partner',
                          subtitle: 'Practice naturally with AI.',
                          gradient: const [
                            Color(0xFF2563EB),
                            Color(0xFF0EA5E9),
                          ],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const AiPracticeSetupScreen(),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: PracticeOptionCard(
                          icon: Icons.groups_rounded,
                          title: 'Live Rooms',
                          subtitle: 'Speak with real learners.',
                          gradient: const [
                            Color(0xFF7C3AED),
                            Color(0xFF8B5CF6),
                          ],
                          onTap: () {
                            _showComingSoon(context, 'Live Rooms');
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Speaking History card
                  InkWell(
                    onTap: () => _openSpeakingHistory(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.history_rounded,
                              color: Color(0xFF2563EB),
                              size: 26,
                            ),
                          ),

                          const SizedBox(width: 14),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Speaking History',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Review your previous AI speaking sessions.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Color(0xFF64748B),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const DailyGoalCard(),

                  const SizedBox(height: 28),

                  const ProgressPreviewCard(),

                  const SizedBox(height: 28),

                  const AchievementPreview(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
