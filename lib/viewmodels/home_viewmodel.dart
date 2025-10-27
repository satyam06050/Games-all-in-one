import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/game_api_model.dart';
import '../services/api_service.dart';
import '../views/webview_screen.dart';
import '../views/favourites_screen.dart';
import '../views/recent_games_screen.dart';
import '../viewmodels/history_viewmodel.dart';
import '../views/history_screen.dart';
import '../views/screenshots_screen.dart';
import '../views/multiplayer_screen.dart';
import '../views/rewards_screen.dart';
import '../views/rating_screen.dart';
import '../views/categories_screen.dart';
import '../views/dashboard_screen.dart';
import '../views/quiz_screen.dart';

class HomeViewModel extends GetxController {
  final isLoading = false.obs;
  final games = <GameApiModel>[].obs;
  final error = ''.obs;

  final List<Map<String, dynamic>> quickActions = [
    {'icon': FontAwesomeIcons.chartLine, 'title': 'Dashboard'},
    {'icon': FontAwesomeIcons.solidHeart, 'title': 'Favourites'},
    {'icon': FontAwesomeIcons.clockRotateLeft, 'title': 'Recent'},
    {'icon': FontAwesomeIcons.trophy, 'title': 'Achievements'},
  ];

  final List<Map<String, dynamic>> modules = [
    {'icon': FontAwesomeIcons.clockRotateLeft, 'title': 'Recent'},
    {'icon': FontAwesomeIcons.solidHeart, 'title': 'Favourites'},
    {'icon': FontAwesomeIcons.layerGroup, 'title': 'Categories'},
    {'icon': FontAwesomeIcons.camera, 'title': 'Screenshots'},
    {'icon': FontAwesomeIcons.userGroup, 'title': 'Multiplayer'},
    {'icon': FontAwesomeIcons.star, 'title': 'Ratings'},
    {'icon': FontAwesomeIcons.chartLine, 'title': 'Dashboard'},
    {'icon': FontAwesomeIcons.trophy, 'title': 'Achievements'},
    {'icon': FontAwesomeIcons.question, 'title': 'Quiz'},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchGames();
  }

  Future<void> fetchGames() async {
    try {
      isLoading.value = true;
      error.value = '';
      final fetchedGames = await ApiService.fetchGames();
      games.value = fetchedGames;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void onGameTap(GameApiModel game, BuildContext context) {
    try {
      final historyViewModel = Get.find<HistoryViewModel>();
      historyViewModel.addToHistory(game);
    } catch (e) {
      // History not available
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewScreen(game: game)),
    );
  }

  void onModuleTap(String title, BuildContext context) {
    switch (title) {
      case 'Favourites':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavouritesScreen()),
        );
        break;
      case 'Recent':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RecentGamesScreen()),
        );
        break;
      case 'History':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
        break;
      case 'Screenshots':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ScreenshotsScreen()),
        );
        break;
      case 'Multiplayer':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MultiplayerScreen()),
        );
        break;
      case 'Rewards':
      case 'Achievements':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RewardsScreen()),
        );
        break;
      case 'Ratings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RatingScreen()),
        );
        break;
      case 'Categories':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CategoriesScreen()),
        );
        break;
      case 'Dashboard':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
        break;
      case 'Quiz':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuizScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title will be available soon!')),
        );
    }
  }

  void onQuickActionTap(String title, BuildContext context) {
    onModuleTap(title, context);
  }

  void onRefresh() {
    fetchGames();
  }
}
