import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../viewmodels/rating_viewmodel.dart';
import '../viewmodels/home_viewmodel.dart';
import '../models/game_api_model.dart';
import '../models/game_rating_model.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(RatingViewModel());
    final homeViewModel = Get.find<HomeViewModel>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          title: const Text('Rate Your Games', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () => _showInfoDialog(context),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'All Games'),
              Tab(text: 'My Ratings'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAllGamesTab(homeViewModel, viewModel, context),
            _buildMyRatingsTab(viewModel, context),
          ],
        ),
      ),
    );
  }

  Widget _buildAllGamesTab(HomeViewModel homeViewModel, RatingViewModel viewModel, BuildContext context) {
    return Obx(() => homeViewModel.games.isEmpty
        ? const Center(child: Text('No games available', style: TextStyle(color: Colors.white70)))
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: homeViewModel.games.length,
            itemBuilder: (context, index) {
              final game = homeViewModel.games[index];
              final rating = viewModel.getRating(game.id);
              return _buildGameCard(game, rating, viewModel, context);
            },
          ));
  }

  Widget _buildGameCard(GameApiModel game, GameRating? rating, RatingViewModel viewModel, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFC8019).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFC8019), Color(0xFFFF9F52)],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Center(
              child: game.icon.startsWith('http')
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.network(
                        game.icon,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Text('🎮', style: TextStyle(fontSize: 40)),
                      ),
                    )
                  : Text(game.icon.isNotEmpty ? game.icon : '🎮', style: const TextStyle(fontSize: 40)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    game.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  if (rating != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(5, (i) => Icon(
                              i < rating.stars ? Icons.star : Icons.star_border,
                              color: const Color(0xFFFC8019),
                              size: 16,
                            )),
                      ],
                    ),
                    if (rating.emoji.isNotEmpty) Text(rating.emoji, style: const TextStyle(fontSize: 20)),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showRatingBottomSheet(context, game, viewModel, rating),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFC8019),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: Text(
                        rating != null ? 'Edit' : 'Rate',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyRatingsTab(RatingViewModel viewModel, BuildContext context) {
    return Obx(() => viewModel.ratings.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_border, size: 80, color: Colors.white30),
                SizedBox(height: 16),
                Text('No ratings yet', style: TextStyle(color: Colors.white70, fontSize: 18)),
                SizedBox(height: 8),
                Text('Rate games to see them here', style: TextStyle(color: Colors.white54, fontSize: 14)),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.ratings.length,
            itemBuilder: (context, index) {
              final rating = viewModel.ratings[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    if (rating.emoji.isNotEmpty)
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFC8019).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: Text(rating.emoji, style: const TextStyle(fontSize: 28))),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(rating.gameName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Row(
                            children: List.generate(5, (i) => Icon(
                                  i < rating.stars ? Icons.star : Icons.star_border,
                                  color: const Color(0xFFFC8019),
                                  size: 18,
                                )),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.trash, color: Colors.red, size: 18),
                      onPressed: () => viewModel.deleteRating(rating.gameId),
                    ),
                  ],
                ),
              );
            },
          ));
  }

  void _showRatingBottomSheet(BuildContext context, GameApiModel game, RatingViewModel viewModel, GameRating? existingRating) {
    if (existingRating != null) {
      viewModel.setStars(existingRating.stars);
      viewModel.setEmoji(existingRating.emoji);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF2C2C2C),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFC8019).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: game.icon.startsWith('http')
                        ? Image.network(
                            game.icon,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Center(child: Text('🎮', style: TextStyle(fontSize: 28))),
                          )
                        : Center(child: Text(game.icon.isNotEmpty ? game.icon : '🎮', style: const TextStyle(fontSize: 28))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(game.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Rate this game:', style: TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 12),
              Obx(() {
                final stars = viewModel.selectedStars.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return GestureDetector(
                      onTap: () => viewModel.setStars((i + 1).toDouble()),
                      child: Icon(
                        i < stars ? Icons.star : Icons.star_border,
                        color: const Color(0xFFFC8019),
                        size: 40,
                      ),
                    );
                  }),
                );
              }),
              const SizedBox(height: 24),
              const Text('Or choose an emoji:', style: TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 12),
              Obx(() {
                final selectedEmoji = viewModel.selectedEmoji.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['😄', '😐', '😡', '❤️', '🤩'].map((emoji) {
                    return GestureDetector(
                      onTap: () => viewModel.setEmoji(emoji),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: selectedEmoji == emoji
                              ? const Color(0xFFFC8019).withValues(alpha: 0.3)
                              : const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedEmoji == emoji ? const Color(0xFFFC8019) : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
                      ),
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 24),
              Row(
                children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      viewModel.selectedStars.value = 0.0;
                      viewModel.selectedEmoji.value = '';
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (viewModel.selectedStars.value > 0 || viewModel.selectedEmoji.value.isNotEmpty) {
                        final isNewRating = existingRating == null;
                        await viewModel.saveRating(game);
                        if (context.mounted) {
                          Navigator.pop(context);
                          if (isNewRating) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('+5 XP earned! 🎉')),
                            );
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFC8019),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save Rating', style: TextStyle(color: Colors.white)),
                  ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFFFC8019)),
            SizedBox(width: 8),
            Text('Local Ratings', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          'All ratings are stored locally on your device. No internet connection needed!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: Color(0xFFFC8019))),
          ),
        ],
      ),
    );
  }
}
