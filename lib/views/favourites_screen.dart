import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../viewmodels/favorites_viewmodel.dart';
import '../controllers/theme_controller.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(FavoritesViewModel());
    final themeController = Get.find<ThemeController>();

    return Obx(() => Scaffold(
      backgroundColor: themeController.gradientColors[0],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeController.gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, viewModel),
              _buildQuickAccessSection(viewModel, context),
              Expanded(
                child: _buildFavoritesList(viewModel, context),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.showAddGamesDialog(context),
        backgroundColor: themeController.buttonColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    ));
  }

  Widget _buildAppBar(BuildContext context, FavoritesViewModel viewModel) {
    final themeController = Get.find<ThemeController>();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeController.accentColor.withValues(alpha: 0.2),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 8),
              const Text(
                'Your Favorites',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: viewModel.toggleEditMode,
            icon: Icon(
              viewModel.isEditMode.value ? Icons.done : Icons.edit,
              color: themeController.accentColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessSection(FavoritesViewModel viewModel, BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Access',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: viewModel.quickAccessGames.isEmpty
                ? Center(
                    child: Text(
                      'Add your favorite games for quick access',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.5),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel.quickAccessGames.length,
                    itemBuilder: (context, index) {
                      final game = viewModel.quickAccessGames[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => viewModel.openGame(game, context),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  themeController.accentColor,
                                  themeController.buttonColor,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: themeController.accentColor.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: game.icon.startsWith('http')
                                  ? ClipOval(
                                      child: Image.network(
                                        game.icon,
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Text('🎮', style: TextStyle(fontSize: 20));
                                        },
                                      ),
                                    )
                                  : Text(
                                      game.icon.isNotEmpty ? game.icon : '🎮',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(FavoritesViewModel viewModel, BuildContext context) {
    final themeController = Get.find<ThemeController>();
    if (viewModel.favoriteGames.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('⭐', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            const Text(
              'You haven\'t added any favorites yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap + to start!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(20),
      onReorder: (oldIndex, newIndex) {
        viewModel.reorderFavorites(oldIndex, newIndex);
        viewModel.showOrderUpdatedMessage(context);
      },
      itemCount: viewModel.favoriteGames.length,
      itemBuilder: (context, index) {
        final game = viewModel.favoriteGames[index];
        return Container(
          key: ValueKey(game.name),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => viewModel.openGame(game, context),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: game.icon.startsWith('http')
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  game.icon,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Text('🎮', style: TextStyle(fontSize: 24));
                                  },
                                ),
                              )
                            : Text(
                                game.icon.isNotEmpty ? game.icon : '🎮',
                                style: const TextStyle(fontSize: 24),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            game.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Last played: 2 days ago',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (viewModel.isEditMode.value)
                      const Icon(
                        Icons.drag_handle,
                        color: Colors.white54,
                        size: 20,
                      )
                    else
                      IconButton(
                        onPressed: () => viewModel.removeFavorite(game),
                        icon: Icon(
                          Icons.favorite,
                          color: themeController.accentColor,
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}