import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/home_view.dart';

class OnboardingController extends GetxController {
  final currentPage = 0.obs;
  final PageController pageController = PageController();
  BuildContext? _context;
  
  void setContext(BuildContext context) {
    _context = context;
  }
  
  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  void onPageChanged(int page) {
    currentPage.value = page;
  }
  
  void skipToEnd() {
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  void completeOnboarding() async {
    if (_context != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_completed_onboarding', true);
      
      Navigator.pushReplacement(
        _context!,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    }
  }
  
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}