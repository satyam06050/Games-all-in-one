import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../viewmodels/webview_viewmodel.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../models/game_api_model.dart';
import '../widgets/shimmer_widget.dart';
import 'screenshot_capture_screen.dart';
import '../viewmodels/screenshot_viewmodel.dart';
import '../controllers/theme_controller.dart';

class WebViewScreen extends StatefulWidget {
  final GameApiModel game;

  const WebViewScreen({super.key, required this.game});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  DateTime? _startTime;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _hasInternet = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  void dispose() async {
    if (_startTime != null) {
      final playTime = DateTime.now().difference(_startTime!).inMinutes;
      if (playTime > 0) {
        final prefs = await SharedPreferences.getInstance();
        final keyTime = 'playtime_${widget.game.id}';
        final keyLast = 'lastplayed_${widget.game.id}';
        final currentTime = prefs.getInt(keyTime) ?? 0;
        await prefs.setInt(keyTime, currentTime + playTime);
        await prefs.setInt(keyLast, DateTime.now().millisecondsSinceEpoch);
        
        final dashboardViewModel = Get.find<DashboardViewModel>();
        dashboardViewModel.addPlaytime(playTime);
        dashboardViewModel.incrementGamesPlayed();
      }
    }
    Get.delete<WebViewViewModel>(tag: widget.game.url);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    if (!_hasInternet) {
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
          title: Text(widget.game.name, style: const TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 80, color: themeController.accentColor),
              const SizedBox(height: 24),
              const Text(
                'No Internet Connection',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please turn on your internet',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  await _checkConnectivity();
                  if (_hasInternet) {
                    setState(() {});
                  }
                },
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text('Reload', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeController.accentColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ));
    }

    final viewModel = Get.put(WebViewViewModel(widget.game), tag: widget.game.url);
    final screenshotViewModel = Get.put(ScreenshotViewModel());

    return Obx(() => ScreenshotCaptureWrapper(
      child: Scaffold(
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
        title: Text(widget.game.name, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Obx(() => IconButton(
            icon: screenshotViewModel.isCapturing.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: screenshotViewModel.isCapturing.value
                ? null
                : () => screenshotViewModel.captureAndSave(context),
          )),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => viewModel.reload(),
          ),
        ],
      ),
      body: Obx(() => Stack(
        children: [
          WebViewWidget(controller: viewModel.webController),
          if (viewModel.isLoading.value)
            Container(
              color: themeController.cardColor,
              child: Column(
                children: [
                  ShimmerWidget(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    borderRadius: 0,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ShimmerWidget(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 24,
                        ),
                        const SizedBox(height: 12),
                        ShimmerWidget(
                          width: MediaQuery.of(context).size.width,
                          height: 16,
                        ),
                        const SizedBox(height: 8),
                        ShimmerWidget(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      )),
    ),
    ));
  }
}
