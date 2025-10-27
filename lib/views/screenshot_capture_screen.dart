import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import '../viewmodels/screenshot_viewmodel.dart';

class ScreenshotCaptureWrapper extends StatelessWidget {
  final Widget child;

  const ScreenshotCaptureWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(ScreenshotViewModel());

    return Screenshot(
      controller: viewModel.screenshotController,
      child: child,
    );
  }
}
