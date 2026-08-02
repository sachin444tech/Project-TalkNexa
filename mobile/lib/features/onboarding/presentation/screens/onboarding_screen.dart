import 'package:flutter/material.dart';
import 'package:mobile/features/onboarding/presentation/models/onboarding_model.dart';
import 'package:mobile/features/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:mobile/features/onboarding/presentation/widgets/page_indicator.dart';
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>{
  final PageController _controller = PageController();

  int currentPage = 0;

  final pages = [
  OnboardingModel(
    title: "Practice English Every Day",
    description:
        "Build confidence by speaking with AI and real learners every day.",
    image: "assets/images/onboarding_1.png",
  ),
  OnboardingModel(
    title: "Your AI English Speaking Partner",
    description:
        "Receive instant feedback on pronunciation, grammar, and fluency during every conversation.",
    image: "assets/images/onboarding_2.png",
  ),
  OnboardingModel(
    title: "Speak with the World",
    description:
        "Join live practice rooms, complete daily speaking challenges, and become fluent with TalkNexa.",
    image: "assets/images/onboarding_3.png",
  ),
];


@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        children: [

          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return OnboardingPage(
                  page: pages[index],
                );
              },
            ),
          ),

          PageIndicator(
            currentIndex: currentPage,
            pageCount: pages.length,
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                TextButton(
                  onPressed: () {
                    _controller.jumpToPage(2);
                  },
                  child: const Text("Skip"),
                ),

                ElevatedButton(
                  onPressed: () {

                    if (currentPage == 2) {

                      // Navigate later

                    } else {

                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );

                    }

                  },
                  child: Text(
                    currentPage == 2
                        ? "Get Started"
                        : "Next",
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 30),

        ],
      ),
    ),
  );
}
}