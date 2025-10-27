import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/game_api_model.dart';

class WebViewViewModel extends GetxController {
  final GameApiModel game;
  late final WebViewController webController;
  final isLoading = true.obs;

  WebViewViewModel(this.game);

  @override
  void onInit() {
    super.onInit();
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => isLoading.value = true,
          onPageFinished: (_) => isLoading.value = false,
        ),
      )
      ..loadRequest(Uri.parse(game.url));
  }

  void reload() => webController.reload();
}
