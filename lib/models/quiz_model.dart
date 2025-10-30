class QuizLevel {
  final int level;
  final int totalQuestions;
  final int maxXP;
  final bool isUnlocked;
  final bool isCompleted;
  final int earnedXP;

  QuizLevel({
    required this.level,
    required this.totalQuestions,
    required this.maxXP,
    this.isUnlocked = false,
    this.isCompleted = false,
    this.earnedXP = 0,
  });

  Map<String, dynamic> toJson() => {
        'level': level,
        'totalQuestions': totalQuestions,
        'maxXP': maxXP,
        'isUnlocked': isUnlocked,
        'isCompleted': isCompleted,
        'earnedXP': earnedXP,
      };

  factory QuizLevel.fromJson(Map<String, dynamic> json) => QuizLevel(
        level: json['level'],
        totalQuestions: json['totalQuestions'],
        maxXP: json['maxXP'],
        isUnlocked: json['isUnlocked'] ?? false,
        isCompleted: json['isCompleted'] ?? false,
        earnedXP: json['earnedXP'] ?? 0,
      );
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String emoji;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.emoji = '🧠',
  });
}
