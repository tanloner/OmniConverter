// lib/pages/settings_page.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../services/ad_service.dart';
import '../widgets/ad_preferences_tile.dart';
import '../widgets/max_combination_size_setting.dart';
import '../widgets/multi_select_dialog.dart';

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
    if (!kIsWeb && Platform.isAndroid) {
      _adService.loadInterstitialAd();
    }

    return PopScope(
      onPopInvoked: (inv) async {
        if (settingsProvider.settings.adPlacements.contains("Interstitial")) {
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
                title: const Text('Ad Placements'),
                subtitle: Text(settings.adPlacements.join(', ')),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  final selected = await showDialog<List<String>>(
                    context: context,
                    builder: (context) => MultiSelectDialog(
                      items: adPlacements,
                      initiallySelected: settings.adPlacements,
                    ),
                  );

                  if (selected != null) {
                    settingsProvider.updateAdPlacements(selected);
                  }
                },
              ),
            const Divider(),
            const MaxCombinationSizeSetting(),
          ],
        ), // Conditional Ad Placement
        bottomNavigationBar: settingsProvider.settings.showAds &&!kIsWeb && Platform.isAndroid &&
                settingsProvider.settings.adPlacements.contains('Bottom Banner')
            ? SizedBox(height: 50, child: _adService.bannerAd())
            : null,
      ),
    );
  }
}
