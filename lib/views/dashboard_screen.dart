import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../controllers/theme_controller.dart';
import 'rating_screen.dart';
import 'rewards_screen.dart';
import 'categories_screen.dart';
import 'recent_games_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(DashboardViewModel());
    final themeController = Get.find<ThemeController>();

    return Obx(() => Scaffold(
      backgroundColor: themeController.gradientColors[0],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, viewModel),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildUserSummaryCard(viewModel),
                _buildQuickActions(context),
                _buildModulesSection(context),
                _buildRecentGamesSection(context),
                _buildStatsFooter(viewModel),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildAppBar(BuildContext context, DashboardViewModel viewModel) {
    final themeController = Get.find<ThemeController>();
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeController.gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: FlexibleSpaceBar(
          centerTitle: true,
          title: const Text(
            'Dashboard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          background: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🎮', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => Text(
                        viewModel.playerName.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserSummaryCard(DashboardViewModel viewModel) {
    final themeController = Get.find<ThemeController>();
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [themeController.accentColor, themeController.buttonColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: themeController.accentColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              '👋 Hi, ${viewModel.playerName.value}!',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => _buildStatItem('🔥 Level ${viewModel.level.value}')),
              Obx(() => _buildStatItem('🪙 ${viewModel.coins.value} Coins')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => _buildStatItem('🎯 XP: ${viewModel.xp.value}')),
              Obx(() => _buildStatItem('⏱️ ${viewModel.playtimeFormatted}')),
            ],
          ),
          const SizedBox(height: 12),
          Obx(
            () => _buildStatItem(
              '🔥 Daily Streak: ${viewModel.dailyStreak.value} Days',
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: viewModel.xpProgress,
                minHeight: 12,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final actions = [
      {'icon': FontAwesomeIcons.gamepad, 'label': 'Play Game', 'route': 'home'},
      {'icon': FontAwesomeIcons.star, 'label': 'Rate Games', 'route': 'rating'},
      {'icon': FontAwesomeIcons.gift, 'label': 'Rewards', 'route': 'rewards'},
      {
        'icon': FontAwesomeIcons.layerGroup,
        'label': 'Categories',
        'route': 'categories',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return GestureDetector(
              onTap: () => _navigateToRoute(context, action['route'] as String),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [themeController.accentColor, themeController.buttonColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: themeController.accentColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      action['icon'] as IconData,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      action['label'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildModulesSection(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final modules = [
      {
        'icon': FontAwesomeIcons.gamepad,
        'title': 'Offline Games',
        'desc': 'Play locally without internet',
      },
      {
        'icon': FontAwesomeIcons.brain,
        'title': 'Local Challenges',
        'desc': 'Test your memory and reflexes',
      },
      {
        'icon': FontAwesomeIcons.layerGroup,
        'title': 'Core Modules',
        'desc': 'Explore game categories and filters',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Modules',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: modules.length,
          itemBuilder: (context, index) {
            final module = modules[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: themeController.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: themeController.accentColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: themeController.accentColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: FaIcon(
                        module['icon'] as IconData,
                        color: themeController.accentColor,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          module['desc'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: themeController.accentColor,
                    size: 16,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentGamesSection(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate adaptive sizes based on screen width
        final cardWidth =
            constraints.maxWidth * 0.28; // About 28% of screen width
        final cardHeight = cardWidth * 1.4; // Keep aspect ratio

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Games',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecentGamesScreen(),
                      ),
                    ),
                    child: Text(
                      'View All',
                      style: TextStyle(color: themeController.accentColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: cardHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    width: cardWidth,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: themeController.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.gamepad,
                          color: themeController.accentColor,
                          size: 20,
                        ),
                        const Text(
                          'Game Name',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (i) => FaIcon(
                              i < 4
                                  ? FontAwesomeIcons.solidStar
                                  : FontAwesomeIcons.star,
                              color: themeController.accentColor,
                              size: 7,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.clock,
                              color: Colors.white70,
                              size: 7,
                            ),
                            SizedBox(width: 2),
                            Text(
                              '12m',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeController.buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            minimumSize: Size.zero,
                          ),
                          child: const Text(
                            'Play',
                            style: TextStyle(color: Colors.white, fontSize: 9),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsFooter(DashboardViewModel viewModel) {
    final themeController = Get.find<ThemeController>();
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeController.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFooterStat(
              FontAwesomeIcons.chartColumn,
              'Games\nPlayed',
              '${viewModel.gamesPlayed.value}',
              themeController,
            ),
            _buildFooterStat(FontAwesomeIcons.trophy, 'Total\nXP', '${viewModel.xp.value}', themeController),
            _buildFooterStat(FontAwesomeIcons.clock, 'Time\nPlayed', viewModel.playtimeFormatted, themeController),
            _buildFooterStat(FontAwesomeIcons.solidHeart, 'Favorites', '${viewModel.favorites.value}', themeController),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterStat(IconData icon, String label, String value, ThemeController themeController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, color: themeController.accentColor, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: themeController.accentColor,
          ),
        ),
      ],
    );
  }

  void _navigateToRoute(BuildContext context, String route) {
    switch (route) {
      case 'home':
        Navigator.pop(context);
        break;
      case 'rating':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RatingScreen()),
        );
        break;
      case 'rewards':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RewardsScreen()),
        );
        break;
      case 'categories':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CategoriesScreen()),
        );
        break;
    }
  }
}
