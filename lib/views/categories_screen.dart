import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../viewmodels/category_viewmodel.dart';
import '../viewmodels/home_viewmodel.dart';
import 'category_games_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(CategoryViewModel());
    final searchController = TextEditingController();

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
        title: const Text('Game Categories', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.filter, color: Colors.white, size: 20),
            onPressed: () => _showFilterSheet(context, viewModel),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(searchController, viewModel),
          Expanded(child: _buildCategoryGrid(viewModel, context)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(TextEditingController controller, CategoryViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onChanged: viewModel.searchGames,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search games or categories...',
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search, color: Color(0xFFFC8019)),
          filled: true,
          fillColor: const Color(0xFF2C2C2C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(CategoryViewModel viewModel, BuildContext context) {
    return Obx(() {
      if (viewModel.searchQuery.value.isNotEmpty) {
        return _buildSearchResults(viewModel, context);
      }
      
      return viewModel.categories.isEmpty
          ? const Center(child: Text('No categories available', style: TextStyle(color: Colors.white70)))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: viewModel.categories.length,
              itemBuilder: (context, index) {
                final category = viewModel.categories[index];
                return _buildCategoryCard(category, viewModel, context);
              },
            );
    });
  }

  Widget _buildSearchResults(CategoryViewModel viewModel, BuildContext context) {
    return Obx(() {
      final games = viewModel.filteredGames;
      
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
              onTap: () {
                final homeViewModel = Get.find<HomeViewModel>();
                homeViewModel.onGameTap(game, context);
              },
            ),
          );
        },
      );
    });
  }

  Widget _buildCategoryCard(dynamic category, CategoryViewModel viewModel, BuildContext context) {
    return GestureDetector(
      onTap: () {
        viewModel.selectCategory(category.id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryGamesScreen(category: category)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFC8019), Color(0xFFFF9F52)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFC8019).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              viewModel.getCategoryIcon(category.icon),
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Obx(() => Text(
                  '${viewModel.getGameCount(category.id)} Games',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, CategoryViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2C),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🎮 Filter Games', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 24),
            const Text('Sort By:', style: TextStyle(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 8),
            Obx(() => Wrap(
                  spacing: 8,
                  children: ['A-Z', 'Z-A', 'Most Played'].map((sort) {
                    return ChoiceChip(
                      label: Text(sort),
                      selected: viewModel.sortBy.value == sort,
                      onSelected: (selected) => viewModel.setSortBy(sort),
                      selectedColor: const Color(0xFFFC8019),
                      labelStyle: TextStyle(color: viewModel.sortBy.value == sort ? Colors.white : Colors.white70),
                      backgroundColor: const Color(0xFF1E1E1E),
                    );
                  }).toList(),
                )),
            const SizedBox(height: 16),
            Obx(() => SwitchListTile(
                  title: const Text('Offline Only', style: TextStyle(color: Colors.white)),
                  value: viewModel.offlineOnly.value,
                  onChanged: (value) => viewModel.toggleOfflineOnly(),
                  activeTrackColor: const Color(0xFFFC8019),
                  tileColor: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                )),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      viewModel.resetFilters();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Reset', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      viewModel.applyFilters();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFC8019),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Apply Filters', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
