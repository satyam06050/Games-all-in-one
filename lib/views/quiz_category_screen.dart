import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../utils/app_res.dart';
import '../widgets/app_card.dart';

import 'quiz_level_screen.dart';

class QuizCategoryScreen extends StatelessWidget {
  const QuizCategoryScreen({super.key});

  final List<Map<String, String>> categories = const [
    {'icon': '🏀', 'title': 'Basketball'},
    {'icon': '⚽', 'title': 'Football'},
    {'icon': '🎾', 'title': 'Tennis'},
    {'icon': '🏈', 'title': 'American Football'},
    {'icon': '🏐', 'title': 'Volleyball'},
    {'icon': '🏓', 'title': 'Table Tennis'},
    {'icon': '🏊', 'title': 'Swimming'},
    {'icon': '🏃', 'title': 'Running'},
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() => Scaffold(
      backgroundColor: AppRes.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeController.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppRes.paddingL),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    ),
                    Text('Choose Category', style: AppRes.headingL),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppRes.paddingL),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppRes.paddingM,
                      mainAxisSpacing: AppRes.paddingM,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return AppCard(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizLevelScreen(category: category['title']!),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category['icon']!,
                              style: const TextStyle(fontSize: 48),
                            ),
                            const SizedBox(height: AppRes.paddingS),
                            Text(
                              category['title']!,
                              style: AppRes.bodyL,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppRes.paddingL),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppRes.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: AppRes.paddingM),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRes.radiusM),
                      ),
                    ),
                    child: Text('Back to Home', style: AppRes.bodyL),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}