import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../viewmodels/quiz_viewmodel.dart';
import '../controllers/theme_controller.dart';
import 'quiz_gameplay_screen.dart';

class QuizLevelSelectionScreen extends StatelessWidget {
  const QuizLevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(QuizViewModel());
    final themeController = Get.find<ThemeController>();

    return Obx(() => Scaffold(
      backgroundColor: themeController.gradientColors[0],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Quiz Challenge', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          _buildHeader(viewModel, themeController),
          Expanded(child: _buildLevelGrid(context, viewModel, themeController)),
        ],
      ),
    ));
  }

  Widget _buildHeader(QuizViewModel viewModel, ThemeController themeController) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeController.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.brain, color: themeController.accentColor, size: 28),
              const SizedBox(width: 12),
              const Text('Choose Your Level', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(FontAwesomeIcons.trophy, 'Total XP', '${viewModel.totalXP.value}', themeController),
                  _buildStatItem(FontAwesomeIcons.circleCheck, 'Completed', '${viewModel.levels.where((l) => l.isCompleted).length}/8', themeController),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, ThemeController themeController) {
    return Column(
      children: [
        FaIcon(icon, color: themeController.accentColor, size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildLevelGrid(BuildContext context, QuizViewModel viewModel, ThemeController themeController) {
    return Obx(() => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: viewModel.levels.length,
          itemBuilder: (context, index) {
            final level = viewModel.levels[index];
            return _buildLevelCard(context, level, viewModel, themeController);
          },
        ));
  }

  Widget _buildLevelCard(BuildContext context, level, QuizViewModel viewModel, ThemeController themeController) {
    final isLocked = !level.isUnlocked;
    final isCompleted = level.isCompleted;

    return GestureDetector(
      onTap: isLocked ? null : () {
        viewModel.startLevel(level.level - 1);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizGameplayScreen()));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: themeController.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLocked ? Colors.grey.withValues(alpha: 0.3) : (isCompleted ? Colors.green : themeController.accentColor),
            width: 2,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: (isLocked ? Colors.grey : (isCompleted ? Colors.green : themeController.accentColor)).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: isLocked
                  ? const FaIcon(FontAwesomeIcons.lock, color: Colors.grey, size: 20)
                  : isCompleted
                      ? const FaIcon(FontAwesomeIcons.circleCheck, color: Colors.green, size: 20)
                      : FaIcon(FontAwesomeIcons.fire, color: themeController.accentColor, size: 20),
            ),
          ),
          title: Text(
            'Level ${level.level}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isLocked ? Colors.grey : Colors.white,
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                '${level.totalQuestions} Questions',
                style: TextStyle(
                  fontSize: 12,
                  color: isLocked ? Colors.grey : Colors.white70,
                ),
              ),
              const SizedBox(width: 8),
              FaIcon(FontAwesomeIcons.star, color: themeController.accentColor, size: 10),
              const SizedBox(width: 4),
              Text(
                isCompleted ? '${level.earnedXP} XP' : '${level.maxXP} XP',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isLocked ? Colors.grey : themeController.accentColor,
                ),
              ),
            ],
          ),
          trailing: isLocked
              ? null
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : themeController.buttonColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isCompleted ? 'Retry' : 'Play',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const FaIcon(FontAwesomeIcons.play, color: Colors.white, size: 10),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
