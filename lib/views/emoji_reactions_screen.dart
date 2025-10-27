import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/multiplayer_viewmodel.dart';
import '../utils/app_res.dart';

class EmojiReactionsScreen extends StatelessWidget {
  const EmojiReactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<MultiplayerViewModel>();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFFFC8019).withValues(alpha: 0.2), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Column(
            children: [
              Text(
                'Emoji & Stickers',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                'Express your victory, defeat, or excitement — offline!',
                style: TextStyle(fontSize: 14, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Emoji Reactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: viewModel.emojis.length,
            itemBuilder: (context, index) {
              final emoji = viewModel.emojis[index];
              return GestureDetector(
                onTap: () {
                  viewModel.selectEmoji(emoji);
                  viewModel.clearEmoji();
                },
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppRes.cardColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppRes.primaryColor.withValues(alpha: 0.3)),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 32)),
                  ),
                ),
              );
            },
          )),
        ),
        const SizedBox(height: 40),
        Obx(() => viewModel.selectedEmoji.value.isNotEmpty
            ? TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Text(
                      viewModel.selectedEmoji.value,
                      style: const TextStyle(fontSize: 120),
                    ),
                  );
                },
              )
            : const SizedBox()),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppRes.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(Icons.celebration, size: 48, color: AppRes.primaryColor),
                const SizedBox(height: 12),
                const Text(
                  'Tap any emoji to see it animate!',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
