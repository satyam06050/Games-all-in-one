import 'package:flutter/material.dart';
import '../utils/app_res.dart';
import '../widgets/app_card.dart';

class QuizLevelScreen extends StatelessWidget {
  final String category;

  const QuizLevelScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppRes.backgroundColor,
      body: SafeArea(
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
                  Text('$category Levels', style: AppRes.headingL),
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
                    childAspectRatio: 1.5,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return AppCard(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Level ${index + 1} - Coming Soon!')),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Level ${index + 1}',
                            style: AppRes.headingS,
                          ),
                          const SizedBox(height: AppRes.paddingS),
                          Text(
                            '${(index + 1) * 5} Questions',
                            style: AppRes.bodyS,
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
                  child: Text('Back to Categories', style: AppRes.bodyL),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}