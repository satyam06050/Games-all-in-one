import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/game_api_model.dart';
import '../views/webview_screen.dart';
import '../views/search_screen.dart';
import 'home_viewmodel.dart';
import 'dashboard_viewmodel.dart';

class FavoritesViewModel extends GetxController {
  final favoriteGames = <GameApiModel>[].obs;
  final isEditMode = false.obs;
  final quickAccessGames = <GameApiModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList('favorites') ?? [];
      
      final homeViewModel = Get.find<HomeViewModel>();
      final allGames = homeViewModel.games;
      
      favoriteGames.value = favoritesJson
          .map((json) {
            final data = jsonDecode(json) as Map<String, dynamic>;
            return allGames.firstWhere(
              (game) => game.id == data['id'],
              orElse: () => GameApiModel.fromJson(data),
            );
          })
          .toList();
      
      updateQuickAccess();
    } catch (e) {
      favoriteGames.clear();
      quickAccessGames.clear();
    }
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = favoriteGames
        .map((game) => jsonEncode(game.toJson()))
        .toList();
    await prefs.setStringList('favorites', favoritesJson);
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  void reorderFavorites(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final item = favoriteGames.removeAt(oldIndex);
    favoriteGames.insert(newIndex, item);
    updateQuickAccess();
    saveFavorites();
  }

  void updateQuickAccess() {
    quickAccessGames.value = favoriteGames.take(4).toList();
  }

  void removeFavorite(GameApiModel game) {
    favoriteGames.remove(game);
    updateQuickAccess();
    saveFavorites();
    _updateDashboard();
  }

  void addToFavorites(GameApiModel game) {
    if (!favoriteGames.any((g) => g.id == game.id)) {
      favoriteGames.add(game);
      updateQuickAccess();
      saveFavorites();
      _updateDashboard();
    }
  }

  void _updateDashboard() {
    if (Get.isRegistered<DashboardViewModel>()) {
      final dashboard = Get.find<DashboardViewModel>();
      dashboard.updateFavoritesCount(favoriteGames.length);
    }
  }

  void openGame(GameApiModel game, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewScreen(game: game)),
    );
  }

  void showAddGamesDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  void showOrderUpdatedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order updated ✅'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}