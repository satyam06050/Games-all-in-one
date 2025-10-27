import 'package:get/get.dart';

class TicTacToeViewModel extends GetxController {
  final board = List.filled(9, '').obs;
  final currentPlayer = 'X'.obs;
  final player1Score = 0.obs;
  final player2Score = 0.obs;
  final winner = ''.obs;
  final showCelebration = false.obs;
  final player1Emoji = ''.obs;
  final player2Emoji = ''.obs;
  final emojis = ['😀', '😎', '😡', '🎉', '💪', '😢', '😂', '🔥'].obs;

  void setPlayerEmoji(String player, String emoji) {
    if (player == 'X') {
      player1Emoji.value = emoji;
    } else {
      player2Emoji.value = emoji;
    }
    Future.delayed(const Duration(seconds: 2), () {
      if (player == 'X') {
        player1Emoji.value = '';
      } else {
        player2Emoji.value = '';
      }
    });
  }

  void makeMove(int index) {
    if (board[index].isEmpty && winner.value.isEmpty) {
      board[index] = currentPlayer.value;
      if (checkWinner()) {
        winner.value = currentPlayer.value;
        if (currentPlayer.value == 'X') {
          player1Score.value++;
        } else {
          player2Score.value++;
        }
        showCelebration.value = true;
        Future.delayed(const Duration(seconds: 2), () {
          showCelebration.value = false;
        });
      } else if (!board.contains('')) {
        winner.value = 'Draw';
      } else {
        currentPlayer.value = currentPlayer.value == 'X' ? 'O' : 'X';
      }
    }
  }

  bool checkWinner() {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]] &&
          board[pattern[0]].isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    board.value = List.filled(9, '');
    currentPlayer.value = 'X';
    winner.value = '';
  }

  void resetScores() {
    player1Score.value = 0;
    player2Score.value = 0;
    resetGame();
  }
}
