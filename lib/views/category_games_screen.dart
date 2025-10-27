import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/category_viewmodel.dart';
import '../viewmodels/home_viewmodel.dart';
import '../views/webview_screen.dart';

class CategoryGamesScreen extends StatelessWidget {
  final dynamic category;

  const CategoryGamesScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<CategoryViewModel>();
    final homeViewModel = Get.find<HomeViewModel>();
    
    viewModel.applyFilters();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
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
        title: Text(category.name, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        final games = viewModel.searchQuery.value.isNotEmpty || viewModel.sortBy.value != 'A-Z'
            ? viewModel.filteredGames
            : homeViewModel.games;
        
        if (games.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('😅', style: TextStyle(fontSize: 80)),
                SizedBox(height: 16),
                Text('No games found', style: TextStyle(color: Colors.white70, fontSize: 18)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFC8019).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: game.icon.startsWith('http')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              game.icon,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Text('🎮', style: TextStyle(fontSize: 24)),
                            ),
                          )
                        : Text(game.icon.isNotEmpty ? game.icon : '🎮', style: const TextStyle(fontSize: 24)),
                  ),
                ),
                title: Text(game.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFFC8019), size: 16),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebViewScreen(game: game)),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
