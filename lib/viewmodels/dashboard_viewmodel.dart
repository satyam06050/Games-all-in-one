import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardViewModel extends GetxController {
  final playerName = 'Player One'.obs;
  final level = 5.obs;
  final coins = 1200.obs;
  final xp = 3400.obs;
  final maxXp = 5000.obs;
  final totalPlaytime = 75.obs; // in minutes
  final dailyStreak = 3.obs;
  final gamesPlayed = 12.obs;
  final favorites = 5.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    playerName.value = prefs.getString('playerName') ?? 'Player One';
    level.value = prefs.getInt('level') ?? 1;
    coins.value = prefs.getInt('coins') ?? 0;
    xp.value = prefs.getInt('xp') ?? 0;
    totalPlaytime.value = prefs.getInt('totalPlaytime') ?? 0;
    dailyStreak.value = prefs.getInt('dailyStreak') ?? 0;
    gamesPlayed.value = prefs.getInt('gamesPlayed') ?? 0;
    favorites.value = prefs.getInt('favorites') ?? 0;
    maxXp.value = level.value * 1000;
  }

  Future<void> saveDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('playerName', playerName.value);
    await prefs.setInt('level', level.value);
    await prefs.setInt('coins', coins.value);
    await prefs.setInt('xp', xp.value);
    await prefs.setInt('totalPlaytime', totalPlaytime.value);
    await prefs.setInt('dailyStreak', dailyStreak.value);
    await prefs.setInt('gamesPlayed', gamesPlayed.value);
    await prefs.setInt('favorites', favorites.value);
  }

  void incrementGamesPlayed() {
    gamesPlayed.value++;
    saveDashboardData();
  }

  void addPlaytime(int minutes) {
    totalPlaytime.value += minutes;
    saveDashboardData();
  }

  void updateFavoritesCount(int count) {
    favorites.value = count;
    saveDashboardData();
  }

  double get xpProgress => xp.value / maxXp.value;

  String get playtimeFormatted {
    final hours = totalPlaytime.value ~/ 60;
    final minutes = totalPlaytime.value % 60;
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }
}
