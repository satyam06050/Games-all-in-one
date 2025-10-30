import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/quiz_model.dart';

class QuizViewModel extends GetxController {
  final levels = <QuizLevel>[].obs;
  final currentLevel = 0.obs;
  final currentQuestion = 0.obs;
  final selectedAnswer = (-1).obs;
  final correctAnswers = 0.obs;
  final lives = 3.obs;
  final totalXP = 0.obs;
  final timeLeft = 20.obs;
  final isAnswered = false.obs;

  final List<List<QuizQuestion>> allQuestions = [
    // Level 1 - Classic Games
    [
      QuizQuestion(question: 'In Tic-Tac-Toe, how many squares are on the board?', options: ['6', '8', '9', '12'], correctIndex: 2, emoji: '⭕'),
      QuizQuestion(question: 'Which piece in Chess can move in an L-shape?', options: ['♟️ Pawn', '♞ Knight', '♝ Bishop', '♜ Rook'], correctIndex: 1, emoji: '♞'),
      QuizQuestion(question: 'What is the goal in Tic-Tac-Toe?', options: ['Fill all squares', 'Get 3 in a row', 'Block opponent', 'Get 4 corners'], correctIndex: 1, emoji: '🎯'),
      QuizQuestion(question: 'How many pieces does each player start with in Chess?', options: ['12', '14', '16', '18'], correctIndex: 2, emoji: '♟️'),
      QuizQuestion(question: 'In multiplayer games, what can you send to react?', options: ['💬 Messages', '😊 Emojis', '🎁 Gifts', '⭐ Stars'], correctIndex: 1, emoji: '😊'),
      QuizQuestion(question: 'Which game uses X and O symbols?', options: ['Chess', 'Tic-Tac-Toe', 'Checkers', 'Sudoku'], correctIndex: 1, emoji: '❌'),
      QuizQuestion(question: 'What happens when you win a game?', options: ['Lose points', 'Earn XP', 'Game over', 'Restart'], correctIndex: 1, emoji: '🏆'),
    ],
    // Level 2 - Game Features
    [
      QuizQuestion(question: 'What can you earn by playing games?', options: ['🪙 Coins & XP', '🎁 Real money', '🏠 Houses', '🚗 Cars'], correctIndex: 0, emoji: '⭐'),
      QuizQuestion(question: 'Where can you find your favorite games?', options: ['❤️ Favorites', '🗑️ Trash', '📧 Email', '📞 Contacts'], correctIndex: 0, emoji: '❤️'),
      QuizQuestion(question: 'What shows your gaming progress?', options: ['Battery', 'Time', 'Dashboard', 'Calendar'], correctIndex: 2, emoji: '📊'),
      QuizQuestion(question: 'How can you play games with friends?', options: ['Solo only', 'Multiplayer mode', 'Watch only', 'Email them'], correctIndex: 1, emoji: '👥'),
      QuizQuestion(question: 'What can you unlock by earning XP?', options: ['New levels', 'New phone', 'New apps', 'New contacts'], correctIndex: 0, emoji: '🔓'),
      QuizQuestion(question: 'Where can you see recently played games?', options: ['Settings', 'Recent Games', 'Downloads', 'Gallery'], correctIndex: 1, emoji: '🕐'),
      QuizQuestion(question: 'What can you do with game screenshots?', options: ['Delete only', 'Share & Save', 'Print only', 'Nothing'], correctIndex: 1, emoji: '📸'),
    ],
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeLevels();
    loadProgress();
  }

  void _initializeLevels() {
    levels.value = List.generate(
      8,
      (i) => QuizLevel(
        level: i + 1,
        totalQuestions: 7,
        maxXP: 100,
        isUnlocked: i == 0,
      ),
    );
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final levelsJson = prefs.getString('quiz_levels');
    final xp = prefs.getInt('quiz_total_xp') ?? 0;
    
    if (levelsJson != null) {
      final List<dynamic> decoded = json.decode(levelsJson);
      levels.value = decoded.map((e) => QuizLevel.fromJson(e)).toList();
    }
    totalXP.value = xp;
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final levelsJson = json.encode(levels.map((e) => e.toJson()).toList());
    await prefs.setString('quiz_levels', levelsJson);
    await prefs.setInt('quiz_total_xp', totalXP.value);
  }

  void startLevel(int level) {
    currentLevel.value = level;
    currentQuestion.value = 0;
    correctAnswers.value = 0;
    lives.value = 3;
    selectedAnswer.value = -1;
    isAnswered.value = false;
    timeLeft.value = 20;
  }

  List<QuizQuestion> getCurrentQuestions() {
    if (currentLevel.value < allQuestions.length) {
      return allQuestions[currentLevel.value];
    }
    return allQuestions[0];
  }

  void selectAnswer(int index) {
    if (!isAnswered.value) {
      selectedAnswer.value = index;
    }
  }

  void submitAnswer() {
    if (selectedAnswer.value == -1 || isAnswered.value) return;
    
    isAnswered.value = true;
    final questions = getCurrentQuestions();
    final isCorrect = selectedAnswer.value == questions[currentQuestion.value].correctIndex;
    
    if (isCorrect) {
      correctAnswers.value++;
    } else {
      lives.value--;
    }
  }

  void nextQuestion() {
    if (currentQuestion.value < getCurrentQuestions().length - 1) {
      currentQuestion.value++;
      selectedAnswer.value = -1;
      isAnswered.value = false;
      timeLeft.value = 20;
    }
  }

  void skipQuestion() {
    nextQuestion();
  }

  bool isLevelComplete() {
    return currentQuestion.value >= getCurrentQuestions().length - 1 && isAnswered.value;
  }

  int calculateEarnedXP() {
    final questions = getCurrentQuestions();
    final percentage = (correctAnswers.value / questions.length);
    return (percentage * 100).round();
  }

  Future<void> completeLevel() async {
    final earnedXP = calculateEarnedXP();
    totalXP.value += earnedXP;
    
    final updatedLevels = levels.map((level) {
      if (level.level == currentLevel.value + 1) {
        return QuizLevel(
          level: level.level,
          totalQuestions: level.totalQuestions,
          maxXP: level.maxXP,
          isUnlocked: level.isUnlocked,
          isCompleted: true,
          earnedXP: earnedXP,
        );
      } else if (level.level == currentLevel.value + 2 && earnedXP >= 70) {
        return QuizLevel(
          level: level.level,
          totalQuestions: level.totalQuestions,
          maxXP: level.maxXP,
          isUnlocked: true,
          isCompleted: level.isCompleted,
          earnedXP: level.earnedXP,
        );
      }
      return level;
    }).toList();
    
    levels.value = updatedLevels;
    await saveProgress();
  }
}
