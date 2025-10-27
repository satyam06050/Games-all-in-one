import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../core/app_res.dart';
import '../controllers/theme_controller.dart';
import '../controllers/settings_controller.dart';
import '../widgets/shared_components.dart';
import 'themes_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final controller = Get.put(SettingsController());
    
    return Obx(() => Scaffold(
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
              SharedComponents.customAppBar(
                title: 'Settings',
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(AppRes.responsivePadding),
                  children: [
                    _buildSettingsSection(
                      'General',
                      [
                        _buildSettingsTile(
                          icon: Icons.notifications,
                          title: 'Notifications',
                          subtitle: 'Manage your notification preferences',
                          onTap: () => _showComingSoon('Notification settings'),
                        ),
                        _buildSettingsTile(
                          icon: Icons.language,
                          title: 'Language',
                          subtitle: 'English',
                          onTap: () => _showComingSoon('Language settings'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppRes.paddingL),
                    
                    _buildSettingsSection(
                      'Appearance',
                      [
                        _buildSettingsTile(
                          icon: Icons.palette,
                          title: 'Themes',
                          subtitle: 'Choose your preferred theme',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ThemesScreen()),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppRes.paddingL),
                    
                    _buildSettingsSection(
                      'Data & Privacy',
                      [
                        _buildSettingsTile(
                          icon: Icons.privacy_tip,
                          title: 'Privacy Policy',
                          subtitle: 'Read our privacy policy',
                          onTap: () => _openPrivacyPolicy(),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppRes.paddingL),
                    
                    _buildSettingsSection(
                      'About',
                      [
                        _buildSettingsTile(
                          icon: Icons.star,
                          title: 'Rate App',
                          subtitle: 'Rate us on the app store',
                          onTap: () => _rateApp(),
                        ),
                        _buildSettingsTile(
                          icon: Icons.share,
                          title: 'Share App',
                          subtitle: 'Share with friends',
                          onTap: () => _shareApp(),
                        ),
                        _buildSettingsTile(
                          icon: Icons.info,
                          title: 'App Version',
                          subtitle: '${controller.appVersion.value} (${controller.buildNumber.value})',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    final themeController = Get.find<ThemeController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppRes.paddingM),
          child: Text(
            title,
            style: AppRes.headingMedium.copyWith(color: themeController.accentColor),
          ),
        ),
        SharedComponents.modernCard(
          padding: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final themeController = Get.find<ThemeController>();
    return ListTile(
      leading: Icon(icon, color: themeController.accentColor),
      title: Text(title, style: AppRes.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
      subtitle: Text(subtitle, style: AppRes.bodySmall.copyWith(color: AppRes.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, color: AppRes.grey, size: 16),
      onTap: onTap,
    );
  }

  void _showComingSoon(String feature) {
    final themeController = Get.find<ThemeController>();
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text('$feature will be available soon!'),
        backgroundColor: themeController.accentColor,
      ),
    );
  }

  Future<void> _openPrivacyPolicy() async {
    try {
      final uri = Uri.parse(AppRes.privacyPolicyUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showError('Cannot open Privacy Policy');
      }
    } catch (e) {
      _showError('Invalid Privacy Policy URL');
    }
  }

  Future<void> _rateApp() async {
    try {
      final uri = Uri.parse(AppRes.playStoreUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showError('Cannot open app store');
      }
    } catch (e) {
      _showError('Invalid app store URL');
    }
  }

  Future<void> _shareApp() async {
    await Share.share(
      'Check out ${AppRes.appName} - ${AppRes.tagline}\n\nDownload: ${AppRes.playStoreUrl}',
      subject: 'Check out ${AppRes.appName}',
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppRes.accentRed,
      ),
    );
  }
}