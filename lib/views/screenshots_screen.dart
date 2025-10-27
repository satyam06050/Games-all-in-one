import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/screenshot_viewmodel.dart';
import '../utils/app_res.dart';
import 'screenshot_viewer_screen.dart';

class ScreenshotsScreen extends StatelessWidget {
  const ScreenshotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(ScreenshotViewModel());

    return Scaffold(
      backgroundColor: AppRes.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppRes.primaryColor,
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
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScreenshotViewerScreen(screenshot: screenshot),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppRes.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.file(
                          File(screenshot.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _formatDate(screenshot.timestamp),
                              style: const TextStyle(fontSize: 12, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: AppRes.primaryColor, size: 20),
                            onPressed: () => _showDeleteDialog(context, viewModel, index),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showDeleteDialog(BuildContext context, ScreenshotViewModel viewModel, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppRes.cardColor,
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
            child: Text('Delete', style: TextStyle(color: AppRes.primaryColor)),
          ),
        ],
      ),
    );
  }
}
