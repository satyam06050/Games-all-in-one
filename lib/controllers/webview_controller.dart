import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/game_api_model.dart';

class GameWebController extends GetxController {
  final isLoading = true.obs;
  late final WebViewController webController;
  final GameApiModel game;

  GameWebController(this.game);

  @override
  void onInit() {
    super.onInit();
    _initWebView();
  }

  void _initWebView() {
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(game.url));
  }
}