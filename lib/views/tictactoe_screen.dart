import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/tictactoe_viewmodel.dart';
import '../utils/app_res.dart';

class TicTacToeScreen extends StatelessWidget {
  const TicTacToeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(TicTacToeViewModel());

    return Scaffold(
      backgroundColor: AppRes.backgroundColor,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFC8019), Color(0xFFFF9F52)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: const Text('Tic-Tac-Toe', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() => Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: _buildPlayerCard('Player 1 (X)', viewModel.player1Score.value, viewModel.currentPlayer.value == 'X', viewModel.player1Emoji.value, () => _showEmojiPicker(context, viewModel, 'X'))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildPlayerCard('Player 2 (O)', viewModel.player2Score.value, viewModel.currentPlayer.value == 'O', viewModel.player2Emoji.value, () => _showEmojiPicker(context, viewModel, 'O'))),
                ],
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => viewModel.makeMove(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppRes.cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppRes.primaryColor.withValues(alpha: 0.3)),
                              ),
                              child: Center(
                                child: Text(
                                  viewModel.board[index],
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: viewModel.board[index] == 'X' ? AppRes.primaryColor : Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              if (viewModel.winner.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        viewModel.winner.value == 'Draw' ? 'It\'s a Draw!' : '${viewModel.winner.value} Wins! 🎉',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => viewModel.resetGame(),
                            style: ElevatedButton.styleFrom(backgroundColor: AppRes.primaryColor),
                            child: const Text('Play Again'),
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(side: BorderSide(color: AppRes.primaryColor)),
                            child: const Text('Back to Games'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
          if (viewModel.showCelebration.value)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Text('🎉', style: TextStyle(fontSize: 120)),
              ),
            ),
        ],
      )),
    );
  }

  Widget _buildPlayerCard(String name, int score, bool isActive, String emoji, VoidCallback onEmojiTap) {
    return GestureDetector(
      onTap: onEmojiTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? AppRes.primaryColor.withValues(alpha: 0.2) : AppRes.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppRes.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(name, style: const TextStyle(fontSize: 16, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Score: $score', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppRes.primaryColor)),
            if (emoji.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(emoji, style: const TextStyle(fontSize: 32)),
            ],
          ],
        ),
      ),
    );
  }

  void _showEmojiPicker(BuildContext context, TicTacToeViewModel viewModel, String player) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppRes.cardColor,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose Emoji', style: TextStyle(fontSize: 18, color: AppRes.primaryColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: viewModel.emojis.map((emoji) => GestureDetector(
                onTap: () {
                  viewModel.setPlayerEmoji(player, emoji);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppRes.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text(emoji, style: const TextStyle(fontSize: 32))),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
