import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/game_rating_model.dart';
import '../models/game_api_model.dart';
import 'home_viewmodel.dart';
import 'rewards_viewmodel.dart';

class RatingViewModel extends GetxController {
  final ratings = <GameRating>[].obs;
  final selectedStars = 0.0.obs;
  final selectedEmoji = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadRatings();
  }

  Future<void> loadRatings() async {
    final prefs = await SharedPreferences.getInstance();
    final ratingsJson = prefs.getStringList('game_ratings') ?? [];
    ratings.value = ratingsJson.map((e) => GameRating.fromJson(jsonDecode(e))).toList();
  }

  Future<void> saveRatings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('game_ratings', ratings.map((e) => jsonEncode(e.toJson())).toList());
  }

  void setStars(double stars) {
    selectedStars.value = stars;
  }

  void setEmoji(String emoji) {
    selectedEmoji.value = emoji;
  }

  Future<void> saveRating(GameApiModel game) async {
    final existingIndex = ratings.indexWhere((r) => r.gameId == game.id);
    final rating = GameRating(
      gameId: game.id,
      gameName: game.name,
      stars: selectedStars.value,
      emoji: selectedEmoji.value,
      ratedAt: DateTime.now(),
    );

    if (existingIndex != -1) {
      ratings[existingIndex] = rating;
    } else {
      ratings.add(rating);
      try {
        final rewardsViewModel = Get.find<RewardsViewModel>();
        rewardsViewModel.addXp(5);
      } catch (e) {
        // Rewards not available
      }
    }

    await saveRatings();
    selectedStars.value = 0.0;
    selectedEmoji.value = '';
  }

  void deleteRating(String gameId) {
    ratings.removeWhere((r) => r.gameId == gameId);
    saveRatings();
  }

  GameRating? getRating(String gameId) {
    try {
      return ratings.firstWhere((r) => r.gameId == gameId);
    } catch (e) {
      return null;
    }
  }

  List<GameApiModel> getRatedGames() {
    try {
      final homeViewModel = Get.find<HomeViewModel>();
      return homeViewModel.games.where((game) => ratings.any((r) => r.gameId == game.id)).toList();
    } catch (e) {
      return [];
    }
  }
}
