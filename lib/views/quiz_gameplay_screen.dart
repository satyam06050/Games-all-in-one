import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import '../viewmodels/quiz_viewmodel.dart';
import '../controllers/theme_controller.dart';
import 'quiz_completion_screen.dart';

class QuizGameplayScreen extends StatefulWidget {
  const QuizGameplayScreen({super.key});

  @override
  State<QuizGameplayScreen> createState() => _QuizGameplayScreenState();
}

class _QuizGameplayScreenState extends State<QuizGameplayScreen> with SingleTickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _startTimer();
  }

  void _startTimer() {
    final viewModel = Get.find<QuizViewModel>();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (viewModel.timeLeft.value > 0 && !viewModel.isAnswered.value) {
        viewModel.timeLeft.value--;
      } else if (viewModel.timeLeft.value == 0 && !viewModel.isAnswered.value) {
        viewModel.submitAnswer();
        Future.delayed(const Duration(seconds: 2), () {
          if (viewModel.isLevelComplete()) {
            _navigateToCompletion();
          } else {
            viewModel.nextQuestion();
            _animationController.forward(from: 0);
            _startTimer();
          }
        });
      }
    });
  }

  void _navigateToCompletion() {
    _timer?.cancel();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const QuizCompletionScreen()));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<QuizViewModel>();
    final themeController = Get.find<ThemeController>();

    return Obx(() => Scaffold(
      backgroundColor: themeController.gradientColors[0],
      body: SafeArea(
        child: Obx(() {
          final questions = viewModel.getCurrentQuestions();
          final question = questions[viewModel.currentQuestion.value];

          return Column(
            children: [
              _buildTopBar(viewModel),
              _buildProgressBar(viewModel, questions.length),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildQuestionCard(question, viewModel),
                      const SizedBox(height: 20),
                      _buildOptionsGrid(question, viewModel),
                      const SizedBox(height: 20),
                      _buildBottomControls(viewModel),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    ));
  }

  Widget _buildTopBar(QuizViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Text('Level ${viewModel.currentLevel.value + 1}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              Obx(() => Row(
                    children: List.generate(3, (i) => Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: FaIcon(
                            i < viewModel.lives.value ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                            color: i < viewModel.lives.value ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                        )),
                  )),
              const SizedBox(width: 12),
              Obx(() => _buildTimer(viewModel.timeLeft.value)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimer(int timeLeft) {
    final themeController = Get.find<ThemeController>();
    final percentage = timeLeft / 20;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            value: percentage,
            strokeWidth: 3,
            backgroundColor: Colors.grey.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              timeLeft > 10 ? themeController.accentColor : Colors.red,
            ),
          ),
        ),
        Text('$timeLeft', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildProgressBar(QuizViewModel viewModel, int total) {
    final themeController = Get.find<ThemeController>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Question ${viewModel.currentQuestion.value + 1} / $total', style: const TextStyle(color: Colors.white70, fontSize: 14)),
              Text('${((viewModel.currentQuestion.value + 1) / total * 100).toInt()}%', style: TextStyle(color: themeController.accentColor, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (viewModel.currentQuestion.value + 1) / total,
              minHeight: 8,
              backgroundColor: Colors.grey.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(themeController.accentColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(question, QuizViewModel viewModel) {
    final themeController = Get.find<ThemeController>();
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: themeController.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: themeController.accentColor.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(question.emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              'Question ${viewModel.currentQuestion.value + 1} of ${viewModel.getCurrentQuestions().length}',
              style: TextStyle(color: themeController.accentColor, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              question.question,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsGrid(question, QuizViewModel viewModel) {
    final themeController = Get.find<ThemeController>();
    return Column(
      children: List.generate(question.options.length, (index) {
        final isSelected = viewModel.selectedAnswer.value == index;
        final isAnswered = viewModel.isAnswered.value;
        final isCorrect = index == question.correctIndex;
        
        Color borderColor = themeController.accentColor;
        Color bgColor = themeController.cardColor;
        
        if (isAnswered) {
          if (isCorrect) {
            borderColor = Colors.green;
            bgColor = Colors.green.withValues(alpha: 0.2);
          } else if (isSelected && !isCorrect) {
            borderColor = Colors.red;
            bgColor = Colors.red.withValues(alpha: 0.2);
          }
        } else if (isSelected) {
          bgColor = themeController.accentColor.withValues(alpha: 0.2);
        }

        return TweenAnimationBuilder(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(50 * (1 - value), 0),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: GestureDetector(
            onTap: isAnswered ? null : () => viewModel.selectAnswer(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: borderColor.withValues(alpha: 0.2),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + index),
                        style: TextStyle(color: borderColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      question.options[index],
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (isAnswered && isCorrect)
                    const FaIcon(FontAwesomeIcons.circleCheck, color: Colors.green, size: 20),
                  if (isAnswered && isSelected && !isCorrect)
                    const FaIcon(FontAwesomeIcons.circleXmark, color: Colors.red, size: 20),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBottomControls(QuizViewModel viewModel) {
    final themeController = Get.find<ThemeController>();
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: viewModel.isAnswered.value ? null : () {
              viewModel.skipQuestion();
              _animationController.forward(from: 0);
              _startTimer();
            },
            icon: const FaIcon(FontAwesomeIcons.forward, size: 16),
            label: const Text('Skip'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white70,
              side: const BorderSide(color: Colors.white70),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: viewModel.selectedAnswer.value == -1 ? null : () {
              if (!viewModel.isAnswered.value) {
                viewModel.submitAnswer();
                _timer?.cancel();
                Future.delayed(const Duration(seconds: 2), () {
                  if (viewModel.isLevelComplete()) {
                    _navigateToCompletion();
                  } else {
                    viewModel.nextQuestion();
                    _animationController.forward(from: 0);
                    _startTimer();
                  }
                });
              }
            },
            icon: const FaIcon(FontAwesomeIcons.arrowRight, size: 16),
            label: Text(viewModel.isAnswered.value ? 'Next' : 'Submit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeController.buttonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 5,
            ),
          ),
        ),
      ],
    );
  }
}
