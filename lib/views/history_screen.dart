import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/history_viewmodel.dart';
import '../utils/app_res.dart';
import '../widgets/shimmer_widget.dart';
import '../controllers/theme_controller.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(HistoryViewModel());
    final themeController = Get.find<ThemeController>();

    return Obx(() => Scaffold(
      backgroundColor: themeController.gradientColors[0],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: themeController.gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: const Text('Game History', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        if (viewModel.isLoading.value) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 6,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: const ShimmerWidget(height: 80, width: double.infinity),
            ),
          );
        }

        if (viewModel.historyGames.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: themeController.accentColor.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                const Text('No games in history', style: TextStyle(color: Colors.white70, fontSize: 18)),
                const SizedBox(height: 8),
                const Text('Games you play will appear here', style: TextStyle(color: Colors.white54, fontSize: 14)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: viewModel.historyGames.length,
          itemBuilder: (context, index) {
            final game = viewModel.historyGames[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: themeController.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: themeController.accentColor.withValues(alpha: 0.2)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppRes.backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: game.icon.startsWith('http')
                      ? ClipOval(
                          child: Image.network(
                            game.icon,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(Icons.games, color: themeController.accentColor),
                          ),
                        )
                      : Center(child: Text(game.icon.isNotEmpty ? game.icon : '🎮', style: const TextStyle(fontSize: 24))),
                ),
                title: Text(
                  game.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    game.url.length > 30 ? '${game.url.substring(0, 30)}...' : game.url,
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: themeController.accentColor, size: 16),
                onTap: () => viewModel.onGameTap(game, context),
              ),
            );
          },
        );
      }),
    ));
  }
}