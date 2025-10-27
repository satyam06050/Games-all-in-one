class QuizLevel {
  final int id;
  final String title;
  final int questions;
  final int maxXP;
  final bool isLocked;
  final int earnedXP;
  final bool isCompleted;

  QuizLevel({
    required this.id,
    required this.title,
    required this.questions,
    required this.maxXP,
    this.isLocked = true,
    this.earnedXP = 0,
    this.isCompleted = false,
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String icon;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.icon,
  });
}
