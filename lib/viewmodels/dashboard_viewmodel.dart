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
    level.value = prefs.getInt('level') ?? 5;
    coins.value = prefs.getInt('coins') ?? 1200;
    xp.value = prefs.getInt('xp') ?? 3400;
    totalPlaytime.value = prefs.getInt('totalPlaytime') ?? 75;
    dailyStreak.value = prefs.getInt('dailyStreak') ?? 3;
    gamesPlayed.value = prefs.getInt('gamesPlayed') ?? 12;
    favorites.value = prefs.getInt('favorites') ?? 5;
  }

  double get xpProgress => xp.value / maxXp.value;

  String get playtimeFormatted {
    final hours = totalPlaytime.value ~/ 60;
    final minutes = totalPlaytime.value % 60;
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }
}
