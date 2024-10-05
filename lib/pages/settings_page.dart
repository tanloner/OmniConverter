// lib/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../services/ad_service.dart';
import '../widgets/ad_preferences_tile.dart';
import '../widgets/max_combination_size_setting.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = '/settings';

  final List<String> adPlacements = [
    'Top Banner',
    'Bottom Banner',
    'Interstitial',
  ];

  final AdService _adService = AdService();

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final settings = settingsProvider.settings;
    _adService.loadInterstitialAd();

    return PopScope(
      onPopInvoked: (inv) async {
        if (settingsProvider.settings.adPlacement == "Interstitial") {
          if (_adService.showInterstitialAd()) {
            await Future.delayed(const Duration(seconds: 1));
          }
        }
      },
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Dark Mode Toggle
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text(
                  'Enable Dark Mode for a better viewing experience.'),
              value: settings.isDarkMode,
              onChanged: (bool value) {
                settingsProvider.toggleDarkMode(value);
              },
            ),
            const Divider(),
            // Ad Preferences
            AdPreferencesTile(
              showAds: settings.showAds,
              onToggleAds: (bool value) {
                settingsProvider.toggleAds(value);
              },
            ),
            if (settings.showAds)
              ListTile(
                title: const Text('Ad Placement'),
                trailing: DropdownButton<String>(
                  value: settings.adPlacement,
                  items: adPlacements
                      .map((placement) => DropdownMenuItem(
                            value: placement,
                            child: Text(placement),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      settingsProvider.updateAdPlacement(newValue);
                    }
                  },
                ),
              ),
            const Divider(),
            const MaxCombinationSizeSetting(),
            // Add More Settings Button
            ListTile(
              title: ElevatedButton(
                onPressed: () {
                  // Placeholder for adding new settings
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Add New Unit'),
                      content: const Text('This feature is under development.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Add New Setting'),
              ),
            ),
          ],
        ), // Conditional Ad Placement
        bottomNavigationBar: settingsProvider.settings.showAds &&
                settingsProvider.settings.adPlacement == 'Bottom Banner'
            ? SizedBox(height: 50, child: _adService.bannerAd())
            : null,
      ),
    );
  }
}
