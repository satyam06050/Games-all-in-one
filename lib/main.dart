import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'viewmodels/counter_view_model.dart';
import 'controllers/theme_controller.dart';
import 'viewmodels/history_viewmodel.dart';
import 'views/splash_screen.dart';
import 'utils/app_res.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CounterController());
    Get.put(ThemeController());
    Get.put(HistoryViewModel(), permanent: true);

    return GetMaterialApp(
      title: AppRes.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: AppRes.primaryColor,
        scaffoldBackgroundColor: AppRes.backgroundColor,
        cardColor: AppRes.cardColor,
        textTheme: ThemeData.dark().textTheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppRes.primaryColor,
            foregroundColor: AppRes.textPrimary,
            textStyle: AppRes.bodyL,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
