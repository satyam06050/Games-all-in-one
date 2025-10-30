import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:confetti/confetti.dart';
import '../viewmodels/quiz_viewmodel.dart';
import '../controllers/theme_controller.dart';

class QuizCompletionScreen extends StatefulWidget {
  const QuizCompletionScreen({super.key});

  @override
  State<QuizCompletionScreen> createState() => _QuizCompletionScreenState();
}

class _QuizCompletionScreenState extends State<QuizCompletionScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
    _completeLevel();
  }

  Future<void> _completeLevel() async {
    final viewModel = Get.find<QuizViewModel>();
    await viewModel.completeLevel();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<QuizViewModel>();
    final themeController = Get.find<ThemeController>();
    final earnedXP = viewModel.calculateEarnedXP();
    final questions = viewModel.getCurrentQuestions();
    final canUnlockNext = earnedXP >= 70;

    return Obx(() => Scaffold(
      backgroundColor: themeController.gradientColors[0],
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: themeController.accentColor,
                          boxShadow: [
                            BoxShadow(
                              color: themeController.accentColor.withValues(alpha: 0.5),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const FaIcon(FontAwesomeIcons.trophy, color: Colors.white, size: 80),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Level Complete!',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 32),
                    _buildStatsCard(viewModel, earnedXP, questions.length, themeController),
                    const SizedBox(height: 32),
                    _buildButtons(context, viewModel, canUnlockNext, themeController),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
              colors: [themeController.accentColor, themeController.buttonColor, Colors.green, Colors.blue, Colors.purple],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildStatsCard(QuizViewModel viewModel, int earnedXP, int totalQuestions, ThemeController themeController) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeController.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: themeController.accentColor, width: 2),
      ),
      child: Column(
        children: [
          _buildStatRow(FontAwesomeIcons.circleCheck, 'Correct', '${viewModel.correctAnswers.value} / $totalQuestions', Colors.green),
          const Divider(color: Colors.white24, height: 32),
          _buildStatRow(FontAwesomeIcons.star, 'XP Earned', '+$earnedXP', themeController.accentColor),
          const Divider(color: Colors.white24, height: 32),
          Obx(() => _buildStatRow(FontAwesomeIcons.trophy, 'Total XP', '${viewModel.totalXP.value}', themeController.accentColor)),
        ],
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            FaIcon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildButtons(BuildContext context, QuizViewModel viewModel, bool canUnlockNext, ThemeController themeController) {
    return Column(
      children: [
        if (canUnlockNext && viewModel.currentLevel.value < 7)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                viewModel.startLevel(viewModel.currentLevel.value + 1);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              icon: const FaIcon(FontAwesomeIcons.arrowRight, size: 20),
              label: const Text('Next Level', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeController.buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
              ),
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  viewModel.startLevel(viewModel.currentLevel.value);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: const FaIcon(FontAwesomeIcons.rotateRight, size: 16),
                label: const Text('Retry'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: const FaIcon(FontAwesomeIcons.house, size: 16),
                label: const Text('Home'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
