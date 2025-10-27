import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_api_model.dart';
import '../services/api_service.dart';
import '../views/webview_screen.dart';

class HistoryViewModel extends GetxController {
  final isLoading = false.obs;
  final games = <GameApiModel>[].obs;
  final historyGames = <GameApiModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList('game_history') ?? [];
      
      final allGames = await ApiService.fetchGames();
      games.value = allGames;
      
      final historyIds = historyJson;
      historyGames.value = allGames.where((game) => historyIds.contains(game.id)).toList();
    } catch (e) {
      historyGames.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToHistory(GameApiModel game) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('game_history') ?? [];
    
    if (!historyJson.contains(game.id)) {
      historyJson.insert(0, game.id);
      if (historyJson.length > 50) historyJson.removeLast();
      await prefs.setStringList('game_history', historyJson);
      loadHistory();
    }
  }

  void onGameTap(GameApiModel game, BuildContext context) {
    addToHistory(game);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewScreen(game: game)),
    );
  }
}