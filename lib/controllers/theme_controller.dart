import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final RxInt selectedTheme = 0.obs;

  final themes = [
    {
      'name': 'Deep Orange',
      'accent': const Color(0xFFFC8019),
      'gradient': [const Color(0xFF121212), const Color(0xFF1F1F1F)],
      'card': const Color(0xFF2D2D2D),
      'button': const Color(0xFFFC8019),
    },
    {
      'name': 'Ocean Blue',
      'accent': const Color(0xFF2196F3),
      'gradient': [const Color(0xFF1A237E), const Color(0xFF0D47A1)],
      'card': const Color(0xFF1565C0),
      'button': const Color(0xFF2196F3),
    },
    {
      'name': 'Purple Dream',
      'accent': const Color(0xFF9C27B0),
      'gradient': [const Color(0xFF4A148C), const Color(0xFF6A1B9A)],
      'card': const Color(0xFF7B1FA2),
      'button': const Color(0xFF9C27B0),
    },
    {
      'name': 'Forest Green',
      'accent': const Color(0xFF4CAF50),
      'gradient': [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
      'card': const Color(0xFF388E3C),
      'button': const Color(0xFF4CAF50),
    },
  ];

  List<Color> get gradientColors =>
      themes[selectedTheme.value]['gradient'] as List<Color>;

  Color get accentColor => themes[selectedTheme.value]['accent'] as Color;

  Color get cardColor => themes[selectedTheme.value]['card'] as Color;

  Color get buttonColor => themes[selectedTheme.value]['button'] as Color;

  void changeTheme(int index) {
    if (index >= 0 && index < themes.length) {
      selectedTheme.value = index;
      Get.changeTheme(
        ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: accentColor,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
      );
    }
  }

  void showToast(String message) {
    Get.snackbar(
      'Theme Updated',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: accentColor.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
