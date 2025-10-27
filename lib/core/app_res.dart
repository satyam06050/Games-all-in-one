import 'package:flutter/material.dart';

class AppRes {
  static const String appName = 'Games All In One';
  static const String tagline = 'Your ultimate gaming destination';
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.example.games_all_in_one';
  
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  
  static double get responsivePadding => paddingM;
  
  static const Color grey = Color(0xFF757575);
  static const Color accentRed = Color(0xFFF44336);
  
  static const TextStyle headingMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
  );
}