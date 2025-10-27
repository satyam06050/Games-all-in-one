import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewmodels/history_viewmodel.dart';
import '../utils/app_res.dart';
import '../widgets/shimmer_widget.dart';

class RecentGamesScreen extends StatefulWidget {
  const RecentGamesScreen({super.key});

  @override
  State<RecentGamesScreen> createState() => _RecentGamesScreenState();
}

class _RecentGamesScreenState extends State<RecentGamesScreen> {
  final Map<String, int> _playTimes = {};
  final Map<String, DateTime> _lastPlayed = {};
  late final HistoryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // Ensure a HistoryViewModel is registered and use it.
    _viewModel = Get.isRegistered<HistoryViewModel>()
        ? Get.find<HistoryViewModel>()
        : Get.put(HistoryViewModel());

    // If history isn't loaded yet, trigger a load.
    if (_viewModel.historyGames.isEmpty) {
      _viewModel.loadHistory();
    }

    // Whenever historyGames changes, refresh the cached play times.
    ever(_viewModel.historyGames, (_) => _loadPlayTimes());

    // Try an initial load (it will no-op if history is empty until filled).
    _loadPlayTimes();
  }

  Future<void> _loadPlayTimes() async {
    // Use the instance we resolved in initState
    try {
      final prefs = await SharedPreferences.getInstance();

      // If there are no history entries yet, clear existing caches and update UI.
      if (_viewModel.historyGames.isEmpty) {
        _playTimes.clear();
        _lastPlayed.clear();
        setState(() {});
        return;
      }

      for (var game in _viewModel.historyGames) {
        final keyTime = 'playtime_${game.id}';
        final keyLast = 'lastplayed_${game.id}';

        final time = prefs.getInt(keyTime) ?? 0;
        final lastPlayedMs =
            prefs.getInt(keyLast) ?? DateTime.now().millisecondsSinceEpoch;

        _playTimes[game.id] = time;
        _lastPlayed[game.id] = DateTime.fromMillisecondsSinceEpoch(
          lastPlayedMs,
        );

        if (!prefs.containsKey(keyLast)) {
          await prefs.setInt(keyLast, lastPlayedMs);
        }
      }

      setState(() {});
    } catch (e) {
      // Fail silently but log during development
      debugPrint('Error loading play times: $e');
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = _viewModel;

    return Obx(() {
      return Scaffold(
        backgroundColor: AppRes.backgroundColor,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFC8019).withValues(alpha: 0.05),
                AppRes.backgroundColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, viewModel),
                Expanded(child: _buildRecentGamesList(viewModel, context)),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAppBar(BuildContext context, HistoryViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const Text(
            'Recent Games',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: viewModel.loadHistory,
            icon: const Icon(Icons.refresh, color: Color(0xFFFC8019), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentGamesList(
    HistoryViewModel viewModel,
    BuildContext context,
  ) {
    if (viewModel.isLoading.value || _playTimes.isEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: const ShimmerWidget(
            width: double.infinity,
            height: 100,
            borderRadius: 16,
          ),
        ),
      );
    }

    if (viewModel.historyGames.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.gamepad_outlined,
              size: 80,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Recent Games',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start playing to see your history',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    final displayGames = viewModel.historyGames.take(5).toList();
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildUsageGraph(),
        const SizedBox(height: 16),
        ...displayGames.asMap().entries.map((entry) {
          final index = entry.key;
          final game = entry.value;
          return TweenAnimationBuilder(
            duration: Duration(milliseconds: 300 + (index * 100)),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: _buildGameCard(game, viewModel, context),
          );
        }),
      ],
    );
  }

  Widget _buildUsageGraph() {
    final totalTime = _playTimes.values.fold(0, (sum, time) => sum + time);
    final hourlyUsage = <int, int>{};

    for (var entry in _lastPlayed.entries) {
      final hour = entry.value.hour;
      final time = _playTimes[entry.key] ?? 0;
      hourlyUsage[hour] = (hourlyUsage[hour] ?? 0) + time;
    }

    final peakHour = hourlyUsage.isEmpty
        ? 0
        : hourlyUsage.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    final maxUsage = hourlyUsage.values.isEmpty
        ? 1
        : hourlyUsage.values.reduce((a, b) => a > b ? a : b);

    final hours = [9, 12, 15, 18, 21, 0];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final graphHeight =
              constraints.maxWidth *
              0.25; // Make graph height relative to width
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Usage by Time of Day',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total Time',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        Text(
                          '${totalTime}m',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFC8019),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Peak Hour',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        Text(
                          '${peakHour % 12 == 0 ? 12 : peakHour % 12}${peakHour >= 12 ? 'PM' : 'AM'}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFC8019),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: graphHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: hours.map((hour) {
                    final usage = hourlyUsage[hour] ?? 0;
                    final height = maxUsage > 0
                        ? (usage / maxUsage) * (graphHeight - 15)
                        : 0.0;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: height,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFC8019),
                                    Color(0xFFFF9F52),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(3),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${hour % 12 == 0 ? 12 : hour % 12}${hour >= 12 ? 'P' : 'A'}',
                              style: const TextStyle(
                                fontSize: 9,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGameCard(
    dynamic game,
    HistoryViewModel viewModel,
    BuildContext context,
  ) {
    final playTime = _playTimes[game.id] ?? 0;
    final lastPlayedTime = _lastPlayed[game.id];
    final timeAgo = lastPlayedTime != null
        ? _getTimeAgo(lastPlayedTime)
        : 'Recently';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => viewModel.onGameTap(game, context),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 90,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFC8019), Color(0xFFFF9F52)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: game.icon.startsWith('http')
                      ? Image.network(
                          game.icon,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                game.icon,
                                style: const TextStyle(fontSize: 30),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            game.icon,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      game.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Last Played: $timeAgo',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total: ${playTime}m',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFC8019),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFC8019), Color(0xFFFF9F52)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Play',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
