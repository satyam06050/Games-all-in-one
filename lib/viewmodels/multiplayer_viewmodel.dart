import 'package:get/get.dart';
import '../models/multiplayer_game_model.dart';

class MultiplayerViewModel extends GetxController {
  final games = <MultiplayerGameModel>[
    MultiplayerGameModel(id: 'tictactoe', name: 'Tic-Tac-Toe', icon: '❌⭕', description: '2 Players | Offline'),
    MultiplayerGameModel(id: 'chess', name: 'Chess', icon: '♟️', description: '2 Players | Offline'),
  ].obs;

  final emojis = ['😀', '😎', '😡', '🎉', '💪', '😢', '😂', '🔥', '👏', '❤️'].obs;
  final selectedEmoji = ''.obs;

  void selectEmoji(String emoji) {
    selectedEmoji.value = emoji;
  }

  void clearEmoji() {
    Future.delayed(const Duration(seconds: 2), () {
      selectedEmoji.value = '';
    });
  }
}
