import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/recent_game_model.dart';
import '../models/game_api_model.dart';
import '../views/webview_screen.dart';

class RecentGamesViewModel extends GetxController {
  final recentGames = <RecentGameModel>[].obs;
  final isLoading = false.obs;
  final totalPlayTime = 0.obs;
  final mostPlayedGame = ''.obs;
  final averageSession = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecentGames();
  }

  void loadRecentGames() {
    isLoading.value = true;
    
    // Mock data - replace with actual storage logic
    recentGames.value = [
      RecentGameModel(
        name: 'Cricket',
        icon: '🏏',
        url: 'https://cricket.com',
        lastPlayed: DateTime.now().subtract(const Duration(hours: 2)),
        sessionMinutes: 45,
        canResume: true,
      ),
      RecentGameModel(
        name: 'Basketball',
        icon: '🏀',
        url: 'https://basketball.com',
        lastPlayed: DateTime.now().subtract(const Duration(hours: 5)),
        sessionMinutes: 30,
        canResume: false,
      ),
      RecentGameModel(
        name: 'Tennis',
        icon: '🎾',
        url: 'https://tennis.com',
        lastPlayed: DateTime.now().subtract(const Duration(days: 1)),
        sessionMinutes: 60,
        canResume: true,
      ),
      RecentGameModel(
        name: 'Football',
        icon: '⚽',
        url: 'https://football.com',
        lastPlayed: DateTime.now().subtract(const Duration(days: 2)),
        sessionMinutes: 90,
        canResume: false,
      ),
    ];

    calculateStats();
    isLoading.value = false;
  }

  void calculateStats() {
    if (recentGames.isEmpty) return;

    // Calculate total play time (this week)
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final thisWeekGames = recentGames.where((game) => game.lastPlayed.isAfter(weekAgo));
    totalPlayTime.value = thisWeekGames.fold(0, (sum, game) => sum + game.sessionMinutes);

    // Find most played game
    final gamePlayTime = <String, int>{};
    for (var game in thisWeekGames) {
      gamePlayTime[game.name] = (gamePlayTime[game.name] ?? 0) + game.sessionMinutes;
    }
    
    if (gamePlayTime.isNotEmpty) {
      final mostPlayed = gamePlayTime.entries.reduce((a, b) => a.value > b.value ? a : b);
      mostPlayedGame.value = '${recentGames.firstWhere((g) => g.name == mostPlayed.key).icon} ${mostPlayed.key}';
    }

    // Calculate average session
    if (thisWeekGames.isNotEmpty) {
      averageSession.value = totalPlayTime.value ~/ thisWeekGames.length;
    }
  }

  void refreshData() {
    loadRecentGames();
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(content: Text('Recent games updated!')),
    );
  }

  void resumeGame(RecentGameModel game, BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildResumeBottomSheet(game, context),
    );
  }

  Widget _buildResumeBottomSheet(RecentGameModel game, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(game.icon, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Continue where you left off?',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Last session saved ${game.timeAgo}',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    openGame(game, context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFC8019)),
                  child: const Text('Resume', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void openGame(RecentGameModel game, BuildContext context) {
    final gameModel = GameApiModel(name: game.name, url: game.url, icon: game.icon);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewScreen(game: gameModel)),
    );
  }

  void clearFromHistory(RecentGameModel game) {
    recentGames.remove(game);
    calculateStats();
  }

  List<RecentGameModel> get todayGames {
    final today = DateTime.now();
    return recentGames.where((game) => 
      game.lastPlayed.day == today.day &&
      game.lastPlayed.month == today.month &&
      game.lastPlayed.year == today.year
    ).toList();
  }

  List<RecentGameModel> get thisWeekGames {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final today = DateTime.now();
    return recentGames.where((game) => 
      game.lastPlayed.isAfter(weekAgo) && 
      !(game.lastPlayed.day == today.day &&
        game.lastPlayed.month == today.month &&
        game.lastPlayed.year == today.year)
    ).toList();
  }

  List<RecentGameModel> get earlierGames {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return recentGames.where((game) => game.lastPlayed.isBefore(weekAgo)).toList();
  }
}