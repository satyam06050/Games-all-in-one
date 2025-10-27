import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/game_api_model.dart';
import '../views/webview_screen.dart';
import 'home_viewmodel.dart';
import 'favorites_viewmodel.dart';

class SearchViewModel extends GetxController {
  final filteredGames = <GameApiModel>[].obs;
  final searchQuery = ''.obs;

  void searchGames(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredGames.clear();
    } else {
      final homeViewModel = Get.find<HomeViewModel>();
      filteredGames.value = homeViewModel.games
          .where((game) => game.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void onGameTap(GameApiModel game, BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewScreen(game: game)),
    );
  }

  void addToFavorites(GameApiModel game, BuildContext context) {
    try {
      final favoritesViewModel = Get.find<FavoritesViewModel>();
      favoritesViewModel.addToFavorites(game);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${game.name} added to favorites!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add to favorites')),
      );
    }
  }
}