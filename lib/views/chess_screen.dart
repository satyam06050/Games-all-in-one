import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/chess_viewmodel.dart';
import '../utils/app_res.dart';

class ChessScreen extends StatelessWidget {
  const ChessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(ChessViewModel());

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
        title: const Text('Chess', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => viewModel.resetGame(),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Obx(() => Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppRes.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppRes.primaryColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: GestureDetector(
                  onTap: () => _showEmojiPicker(context, viewModel, 'white'),
                  child: Column(
                    children: [
                      const Text('White', style: TextStyle(fontSize: 16, color: Colors.white)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: viewModel.currentPlayer.value == 'white'
                              ? AppRes.primaryColor.withValues(alpha: 0.3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          viewModel.currentPlayer.value == 'white' ? 'Your Turn' : 'Waiting',
                          style: TextStyle(
                            fontSize: 14,
                            color: viewModel.currentPlayer.value == 'white' ? AppRes.primaryColor : Colors.white54,
                          ),
                        ),
                      ),
                      if (viewModel.whiteEmoji.value.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(viewModel.whiteEmoji.value, style: const TextStyle(fontSize: 32)),
                      ],
                    ],
                  ),
                )),
                const SizedBox(width: 16),
                Expanded(child: GestureDetector(
                  onTap: () => _showEmojiPicker(context, viewModel, 'black'),
                  child: Column(
                    children: [
                      const Text('Black', style: TextStyle(fontSize: 16, color: Colors.white)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: viewModel.currentPlayer.value == 'black'
                              ? AppRes.primaryColor.withValues(alpha: 0.3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          viewModel.currentPlayer.value == 'black' ? 'Your Turn' : 'Waiting',
                          style: TextStyle(
                            fontSize: 14,
                            color: viewModel.currentPlayer.value == 'black' ? AppRes.primaryColor : Colors.white54,
                          ),
                        ),
                      ),
                      if (viewModel.blackEmoji.value.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(viewModel.blackEmoji.value, style: const TextStyle(fontSize: 32)),
                      ],
                    ],
                  ),
                )),
              ],
            ),
          )),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() {
                    final boardData = viewModel.board.value;
                    final selected = viewModel.selectedPiece.value;
                    
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: 64,
                      itemBuilder: (context, index) {
                        final row = index ~/ 8;
                        final col = index % 8;
                        final isLight = (row + col) % 2 == 0;
                        final piece = boardData[row][col];
                        final isSelected = selected != null &&
                            selected[0] == row &&
                            selected[1] == col;

                        return GestureDetector(
                          onTap: () => viewModel.selectSquare(row, col),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppRes.primaryColor.withValues(alpha: 0.5)
                                  : isLight
                                      ? const Color(0xFFEEEED2)
                                      : const Color(0xFF769656),
                            ),
                            child: Center(
                              child: Text(
                                piece,
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppRes.primaryColor,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Back to Games'),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmojiPicker(BuildContext context, ChessViewModel viewModel, String player) {
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
