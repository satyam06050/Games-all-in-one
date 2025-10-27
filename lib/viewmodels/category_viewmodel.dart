import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/category_model.dart';
import '../models/game_api_model.dart';
import 'home_viewmodel.dart';

class CategoryViewModel extends GetxController {
  final categories = <GameCategory>[].obs;
  final filteredGames = <GameApiModel>[].obs;
  final searchQuery = ''.obs;
  final selectedCategory = ''.obs;
  final sortBy = 'A-Z'.obs;
  final offlineOnly = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeCategories();
    applyFilters();
  }

  void initializeCategories() {
    categories.value = [
      GameCategory(id: 'arcade', name: 'Arcade', icon: 'gamepad', gameIds: []),
      GameCategory(id: 'puzzle', name: 'Puzzle', icon: 'puzzlePiece', gameIds: []),
      GameCategory(id: 'sports', name: 'Sports', icon: 'futbol', gameIds: []),
      GameCategory(id: 'memory', name: 'Memory', icon: 'brain', gameIds: []),
      GameCategory(id: 'trending', name: 'Trending', icon: 'fire', gameIds: []),
      GameCategory(id: 'action', name: 'Action', icon: 'bolt', gameIds: []),
    ];
  }

  IconData getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'gamepad':
        return FontAwesomeIcons.gamepad;
      case 'puzzlePiece':
        return FontAwesomeIcons.puzzlePiece;
      case 'futbol':
        return FontAwesomeIcons.futbol;
      case 'brain':
        return FontAwesomeIcons.brain;
      case 'fire':
        return FontAwesomeIcons.fire;
      case 'bolt':
        return FontAwesomeIcons.bolt;
      default:
        return FontAwesomeIcons.gamepad;
    }
  }

  void searchGames(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void selectCategory(String categoryId) {
    selectedCategory.value = categoryId;
    applyFilters();
  }

  void setSortBy(String sort) {
    sortBy.value = sort;
    applyFilters();
  }

  void toggleOfflineOnly() {
    offlineOnly.value = !offlineOnly.value;
    applyFilters();
  }

  void applyFilters() {
    try {
      final homeViewModel = Get.find<HomeViewModel>();
      var games = homeViewModel.games.toList();

      if (searchQuery.value.isNotEmpty) {
        games = games.where((game) => game.name.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
      }

      if (sortBy.value == 'A-Z') {
        games.sort((a, b) => a.name.compareTo(b.name));
      } else if (sortBy.value == 'Z-A') {
        games.sort((a, b) => b.name.compareTo(a.name));
      }

      filteredGames.value = games;
    } catch (e) {
      filteredGames.clear();
    }
  }

  void resetFilters() {
    selectedCategory.value = '';
    sortBy.value = 'A-Z';
    offlineOnly.value = false;
    searchQuery.value = '';
    applyFilters();
  }

  int getGameCount(String categoryId) {
    try {
      final homeViewModel = Get.find<HomeViewModel>();
      return homeViewModel.games.length;
    } catch (e) {
      return 0;
    }
  }
}
