import 'package:get/get.dart';

class QuizViewModel extends GetxController {
  final currentQuestionIndex = 0.obs;
  final score = 0.obs;
  final isQuizStarted = false.obs;

  void startQuiz() {
    isQuizStarted.value = true;
    currentQuestionIndex.value = 0;
    score.value = 0;
  }

  void nextQuestion() {
    currentQuestionIndex.value++;
  }

  void addScore() {
    score.value++;
  }

  void resetQuiz() {
    isQuizStarted.value = false;
    currentQuestionIndex.value = 0;
    score.value = 0;
  }
}