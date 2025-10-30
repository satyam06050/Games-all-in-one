import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import '../models/screenshot_model.dart';

class ScreenshotViewModel extends GetxController {
  final screenshotController = ScreenshotController();
  final screenshots = <ScreenshotModel>[].obs;
  final isCapturing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadScreenshots();
  }

  Future<void> loadScreenshots() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('screenshots') ?? [];
    screenshots.value = data.map((e) => ScreenshotModel.fromJson(json.decode(e))).toList();
  }

  Future<void> captureAndSave(BuildContext context) async {
    try {
      isCapturing.value = true;

      final image = await screenshotController.capture();
      if (image == null) return;

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(image);

      final screenshot = ScreenshotModel(path: file.path, timestamp: DateTime.now());
      screenshots.insert(0, screenshot);

      final prefs = await SharedPreferences.getInstance();
      final data = screenshots.map((e) => json.encode(e.toJson())).toList();
      await prefs.setStringList('screenshots', data);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Screenshot saved successfully!'),
            backgroundColor: Color(0xFFFC8019),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save screenshot: $e')),
        );
      }
    } finally {
      isCapturing.value = false;
    }
  }

  Future<void> deleteScreenshot(int index) async {
    final file = File(screenshots[index].path);
    if (await file.exists()) await file.delete();
    
    screenshots.removeAt(index);
    
    final prefs = await SharedPreferences.getInstance();
    final data = screenshots.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('screenshots', data);
  }

  Future<void> saveToGallery(BuildContext context, String path) async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission denied')),
          );
        }
        return;
      }

      final file = File(path);
      final fileName = 'Games_${DateTime.now().millisecondsSinceEpoch}.png';
      final directory = Directory('/storage/emulated/0/Pictures/GamesAllInOne');
      
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final newFile = File('${directory.path}/$fileName');
      await file.copy(newFile.path);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Screenshot saved to gallery!'),
            backgroundColor: Color(0xFFFC8019),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    }
  }
}
