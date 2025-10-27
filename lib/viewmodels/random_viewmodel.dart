import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/home_viewmodel.dart';
import '../views/webview_screen.dart';

class RandomViewModel extends GetxController {
  void getRandomGame(BuildContext context) {
    final homeViewModel = Get.find<HomeViewModel>();
    if (homeViewModel.games.isNotEmpty) {
      final randomIndex = DateTime.now().millisecondsSinceEpoch % homeViewModel.games.length;
      final randomGame = homeViewModel.games[randomIndex];
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebViewScreen(game: randomGame)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No games available')),
      );
    }
  }
}