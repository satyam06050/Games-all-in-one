import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsController extends GetxController {
  final appVersion = '1.0.0'.obs;
  final buildNumber = '1'.obs;

  @override
  void onInit() {
    super.onInit();
    _getAppInfo();
  }

  Future<void> _getAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = packageInfo.version;
      buildNumber.value = packageInfo.buildNumber;
    } catch (e) {
      // Keep default values if package info fails
    }
  }
}