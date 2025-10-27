import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/reward_model.dart';

class RewardsViewModel extends GetxController {
  final xp = 0.obs;
  final coins = 0.obs;
  final level = 1.obs;
  final maxXp = 2000.obs;
  final dailyRewards = <DailyReward>[].obs;
  final challenges = <Challenge>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
    initializeDailyRewards();
    initializeChallenges();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    xp.value = prefs.getInt('xp') ?? 0;
    coins.value = prefs.getInt('coins') ?? 0;
    level.value = prefs.getInt('level') ?? 1;
    maxXp.value = level.value * 2000;

    final rewardsJson = prefs.getStringList('dailyRewards');
    if (rewardsJson != null) {
      dailyRewards.value = rewardsJson.map((e) => DailyReward.fromJson(jsonDecode(e))).toList();
    }

    final challengesJson = prefs.getStringList('challenges');
    if (challengesJson != null) {
      challenges.value = challengesJson.map((e) => Challenge.fromJson(jsonDecode(e))).toList();
    }
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', xp.value);
    await prefs.setInt('coins', coins.value);
    await prefs.setInt('level', level.value);
    await prefs.setStringList('dailyRewards', dailyRewards.map((e) => jsonEncode(e.toJson())).toList());
    await prefs.setStringList('challenges', challenges.map((e) => jsonEncode(e.toJson())).toList());
  }

  void initializeDailyRewards() {
    if (dailyRewards.isEmpty) {
      dailyRewards.value = List.generate(
        7,
        (i) => DailyReward(day: i + 1, xp: (i + 1) * 10, claimed: false),
      );
    }
  }

  void initializeChallenges() {
    if (challenges.isEmpty) {
      challenges.value = [
        Challenge(id: '1', title: 'Play 3 Games Today', icon: '🎯', reward: 100, rewardType: 'XP', current: 0, target: 3, completed: false),
        Challenge(id: '2', title: 'Win a Match', icon: '🏆', reward: 50, rewardType: 'XP', current: 0, target: 1, completed: false),
        Challenge(id: '3', title: 'Upload Screenshot', icon: '📸', reward: 20, rewardType: 'Coins', current: 0, target: 1, completed: false),
      ];
    }
  }

  void claimDailyReward(int day) {
    final index = dailyRewards.indexWhere((r) => r.day == day);
    if (index != -1 && !dailyRewards[index].claimed) {
      addXp(dailyRewards[index].xp);
      dailyRewards[index] = DailyReward(day: day, xp: dailyRewards[index].xp, claimed: true);
      dailyRewards.refresh();
      saveData();
    }
  }

  void claimChallenge(String id) {
    final index = challenges.indexWhere((c) => c.id == id);
    if (index != -1 && challenges[index].completed) {
      if (challenges[index].rewardType == 'XP') {
        addXp(challenges[index].reward);
      } else {
        addCoins(challenges[index].reward);
      }
      challenges.removeAt(index);
      challenges.refresh();
      saveData();
    }
  }

  void addXp(int amount) {
    xp.value += amount;
    if (xp.value >= maxXp.value) {
      xp.value -= maxXp.value;
      level.value++;
      maxXp.value = level.value * 2000;
    }
    saveData();
  }

  void addCoins(int amount) {
    coins.value += amount;
    saveData();
  }

  void updateChallengeProgress(String id, int progress) {
    final index = challenges.indexWhere((c) => c.id == id);
    if (index != -1) {
      final challenge = challenges[index];
      challenges[index] = Challenge(
        id: challenge.id,
        title: challenge.title,
        icon: challenge.icon,
        reward: challenge.reward,
        rewardType: challenge.rewardType,
        current: progress,
        target: challenge.target,
        completed: progress >= challenge.target,
      );
      challenges.refresh();
      saveData();
    }
  }

  double get progress => xp.value / maxXp.value;
}
