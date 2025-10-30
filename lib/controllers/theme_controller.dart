import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final RxInt selectedTheme = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    selectedTheme.value = prefs.getInt('selected_theme') ?? 0;
  }

  Future<void> saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_theme', selectedTheme.value);
  }

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
    {
      'name': 'Sunset Red',
      'accent': const Color(0xFFFF5252),
      'gradient': [const Color(0xFFB71C1C), const Color(0xFFC62828)],
      'card': const Color(0xFFD32F2F),
      'button': const Color(0xFFFF5252),
    },
    {
      'name': 'Cyan Wave',
      'accent': const Color(0xFF00BCD4),
      'gradient': [const Color(0xFF006064), const Color(0xFF00838F)],
      'card': const Color(0xFF0097A7),
      'button': const Color(0xFF00BCD4),
    },
    {
      'name': 'Golden Hour',
      'accent': const Color(0xFFFFB300),
      'gradient': [const Color(0xFFE65100), const Color(0xFFF57C00)],
      'card': const Color(0xFFFB8C00),
      'button': const Color(0xFFFFB300),
    },
    {
      'name': 'Pink Blossom',
      'accent': const Color(0xFFE91E63),
      'gradient': [const Color(0xFF880E4F), const Color(0xFFC2185B)],
      'card': const Color(0xFFD81B60),
      'button': const Color(0xFFE91E63),
    },
    {
      'name': 'Teal Mint',
      'accent': const Color(0xFF009688),
      'gradient': [const Color(0xFF004D40), const Color(0xFF00695C)],
      'card': const Color(0xFF00796B),
      'button': const Color(0xFF009688),
    },
    {
      'name': 'Indigo Night',
      'accent': const Color(0xFF3F51B5),
      'gradient': [const Color(0xFF1A237E), const Color(0xFF283593)],
      'card': const Color(0xFF303F9F),
      'button': const Color(0xFF3F51B5),
    },
    {
      'name': 'Lime Fresh',
      'accent': const Color(0xFFCDDC39),
      'gradient': [const Color(0xFF827717), const Color(0xFF9E9D24)],
      'card': const Color(0xFFAFB42B),
      'button': const Color(0xFFCDDC39),
    },
    {
      'name': 'Dark Slate',
      'accent': const Color(0xFF607D8B),
      'gradient': [const Color(0xFF263238), const Color(0xFF37474F)],
      'card': const Color(0xFF455A64),
      'button': const Color(0xFF607D8B),
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
      saveTheme();
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
