import 'dart:io';
import 'package:flutter/material.dart';
import '../models/screenshot_model.dart';
import '../utils/app_res.dart';

class ScreenshotViewerScreen extends StatelessWidget {
  final ScreenshotModel screenshot;

  const ScreenshotViewerScreen({super.key, required this.screenshot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppRes.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppRes.primaryColor,
        title: const Text('Screenshot', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(File(screenshot.path)),
        ),
      ),
    );
  }
}
