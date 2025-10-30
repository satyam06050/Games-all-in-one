import 'package:get/get.dart';
import '../models/game_api_model.dart';
import '../services/api_service.dart';
import '../views/webview_screen.dart';
import '../views/favourites_screen.dart';

class HomeController extends GetxController {
  final isLoading = false.obs;
  final games = <GameApiModel>[].obs;
  final error = ''.obs;
  
  final List<Map<String, String>> quickActions = [
    {'icon': '🧮', 'title': 'BMI Calculator'},
    {'icon': '🔥', 'title': 'Calorie Burn'},
    {'icon': '👣', 'title': 'Step Counter'},
    {'icon': '💧', 'title': 'Water Intake'},
    {'icon': '⏱️', 'title': 'Workout Timer'},
    {'icon': '🏀', 'title': 'Sports Trivia'},
    {'icon': '🧠', 'title': 'Quiz'},
  ];
  
  final List<Map<String, String>> modules = [
    {'icon': '📊', 'title': 'Progress'},
    {'icon': '🏆', 'title': 'Achievements'},
    {'icon': '📅', 'title': 'Schedule'},
    {'icon': '⭐', 'title': 'Favourites'},
    {'icon': '📚', 'title': 'Guide'},
    {'icon': '🎪', 'title': 'Events'},
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
  
  void onGameTap(GameApiModel game) {
    Get.to(() => WebViewScreen(game: game));
  }
  
  void onQuickActionTap(String title) {
    Get.snackbar('Quick Action', '$title feature coming soon!');
  }
  
  void onModuleTap(String title) {
    switch (title) {
      case 'Favourites':
        Get.to(() => const FavouritesScreen());
        break;
      default:
        Get.snackbar('Module', '$title will be available soon!');
    }
  }
  
  void onRefresh() {
    fetchGames();
  }
}