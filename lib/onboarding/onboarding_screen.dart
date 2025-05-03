import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../auth/auth_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 2);
            },
            children: [
              _buildPage(
                context,
                title: "Track Your Habits",
                subtitle: "Build a greener routine by logging eco-friendly actions each day.",
                animationPath: "assets/lottie/eco_earth.json",
              ),
              _buildPage(
                context,
                title: "Save Natural Resources",
                subtitle: "Reduce waste, conserve energy, and earn eco points for your efforts.",
                animationPath: "assets/lottie/save_water.json",
              ),
              _buildPage(
                context,
                title: "Join a Green Movement",
                subtitle: "Be part of a growing community creating impact through small changes.",
                animationPath: "assets/lottie/recycle.json",
              ),
            ],
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: isLastPage
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const AuthPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Get Started"),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const AuthPage()),
                          );
                        },
                        child: const Text("Skip"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text("Next"),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context, {
    required String title,
    required String subtitle,
    required String animationPath,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animationPath, height: 250),
          const SizedBox(height: 30),
          Text(
            title,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            subtitle,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
