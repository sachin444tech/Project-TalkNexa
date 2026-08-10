import 'package:flutter/material.dart';


import 'package:mobile/app/theme/app_colors.dart';
import '../models/practice_scenario.dart';
import '../widgets/difficulty_selector.dart';
import '../widgets/duration_selector.dart';
import '../widgets/practice_scenario_card.dart';

class AiPracticeSetupScreen extends StatefulWidget {
  const AiPracticeSetupScreen({
    super.key,
  });

  @override
  State<AiPracticeSetupScreen> createState() =>
      _AiPracticeSetupScreenState();
}

class _AiPracticeSetupScreenState
    extends State<AiPracticeSetupScreen> {
  int selectedScenario = 0;

  String selectedDifficulty = 'Beginner';

  int selectedDuration = 10;

  final scenarios = const [
    PracticeScenario(
      title: 'Casual Conversation',
      description:
          'Talk naturally about everyday topics.',
      icon: Icons.coffee_rounded,
      gradient: [
        AppColors.primary,
        AppColors.accent,
      ],
    ),
    PracticeScenario(
      title: 'Job Interview',
      description:
          'Practice answering professional questions.',
      icon: Icons.business_center_rounded,
      gradient: [
        AppColors.secondary,
        Color(0xFF8B5CF6),
      ],
    ),
    PracticeScenario(
      title: 'Travel',
      description:
          'Practice English for real travel situations.',
      icon: Icons.flight_takeoff_rounded,
      gradient: [
        Color(0xFF0EA5E9),
        Color(0xFF06B6D4),
      ],
    ),
    PracticeScenario(
      title: 'College',
      description:
          'Practice conversations for student life.',
      icon: Icons.school_rounded,
      gradient: [
        Color(0xFFF59E0B),
        Color(0xFFF97316),
      ],
    ),
    PracticeScenario(
      title: 'Daily Life',
      description:
          'Improve English through everyday situations.',
      icon: Icons.home_rounded,
      gradient: [
        Color(0xFF10B981),
        Color(0xFF14B8A6),
      ],
    ),
    PracticeScenario(
      title: 'Role Play',
      description:
          'Practice realistic English scenarios.',
      icon: Icons.theater_comedy_rounded,
      gradient: [
        Color(0xFFEC4899),
        Color(0xFFF43F5E),
      ],
    ),
  ];

  void _startPractice() {
    final scenario =
        scenarios[selectedScenario];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${scenario.title} • '
          '$selectedDifficulty • '
          '$selectedDuration min',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),
        title: const Text(
          'AI Speaking Practice',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  30,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primary,
                            Color(0xFF0EA5E9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(26),
                      ),
                      child: const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 28,
                          ),

                          SizedBox(height: 18),

                          Text(
                            'Build confidence\nthrough conversation.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              height: 1.1,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),

                          SizedBox(height: 10),

                          Text(
                            'Choose how you want to practice and let TalkNexa guide the conversation.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Choose a scenario',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'What would you like to practice today?',
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    ...List.generate(
                      scenarios.length,
                      (index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child:
                              PracticeScenarioCard(
                            scenario: scenarios[index],
                            isSelected:
                                selectedScenario ==
                                    index,
                            onTap: () {
                              setState(() {
                                selectedScenario =
                                    index;
                              });
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Difficulty',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 14),

                    DifficultySelector(
                      selectedDifficulty:
                          selectedDifficulty,
                      onChanged: (value) {
                        setState(() {
                          selectedDifficulty =
                              value;
                        });
                      },
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Practice duration',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 14),

                    DurationSelector(
                      selectedDuration:
                          selectedDuration,
                      onChanged: (value) {
                        setState(() {
                          selectedDuration = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                14,
                20,
                20,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.06,
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _startPractice,
                  icon: const Icon(
                    Icons.mic_rounded,
                  ),
                  label: const Text(
                    'Start AI Practice',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}