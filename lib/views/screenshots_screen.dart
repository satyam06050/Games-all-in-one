import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../viewmodels/screenshot_viewmodel.dart';
import '../controllers/theme_controller.dart';
import 'screenshot_viewer_screen.dart';

class ScreenshotsScreen extends StatelessWidget {
  const ScreenshotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(ScreenshotViewModel());
    final themeController = Get.find<ThemeController>();

    return Obx(() => Scaffold(
      backgroundColor: themeController.gradientColors[0],
      appBar: AppBar(
        backgroundColor: themeController.accentColor,
        title: const Text('Saved Screenshots', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        if (viewModel.screenshots.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.photo_library, size: 64, color: Colors.white54),
                const SizedBox(height: 16),
                const Text(
                  'No screenshots yet',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Capture your game highlights to see them here!',
                  style: TextStyle(fontSize: 14, color: Colors.white54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: viewModel.screenshots.length,
          itemBuilder: (context, index) {
            final screenshot = viewModel.screenshots[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScreenshotViewerScreen(screenshot: screenshot),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(screenshot.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _formatDate(screenshot.timestamp),
                        style: const TextStyle(fontSize: 11, color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => viewModel.saveToGallery(context, screenshot.path),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: FaIcon(FontAwesomeIcons.download, color: themeController.accentColor, size: 16),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () => _showDeleteDialog(context, viewModel, index),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: FaIcon(FontAwesomeIcons.trash, color: themeController.accentColor, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    ));
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showDeleteDialog(BuildContext context, ScreenshotViewModel viewModel, int index) {
    showDialog(
      context: context,
      builder: (context) {
        final themeController = Get.find<ThemeController>();
        return AlertDialog(
        backgroundColor: themeController.cardColor,
        title: const Text('Delete Screenshot', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this screenshot?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteScreenshot(index);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: themeController.accentColor, fontWeight: FontWeight.bold)),
          ),
        ],
      );},
    );
  }
}
