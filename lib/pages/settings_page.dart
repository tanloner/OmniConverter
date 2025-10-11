// lib/pages/settings_page.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/settings.dart';
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

    // Load interstitial ad only on Android
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
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              // Web/Desktop Layout
              return Center(
                child: Container(
                  width: 700,
                  padding: const EdgeInsets.all(16),
                  child: _buildSettingsList(context, settingsProvider, settings),
                ),
              );
            } else {
              // Mobile Layout
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildSettingsList(context, settingsProvider, settings),
              );
            }
          },
        ),
        bottomNavigationBar: _buildBottomAd(settingsProvider),
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context, SettingsProvider settingsProvider, Settings settings) {
    return ListView(
      children: [
        // Dark Mode Toggle
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: SwitchListTile(
            secondary: Icon(
              settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable Dark Mode for a better viewing experience.'),
            value: settings.isDarkMode,
            onChanged: (bool value) {
              settingsProvider.toggleDarkMode(value);
            },
          ),
        ),
        const SizedBox(height: 8),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: SwitchListTile(
            secondary: Icon(
              settings.showBaseUnits ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text('Base Units'),
            subtitle: const Text('Display your Unit of Formula in Base Units'),
            value: settings.showBaseUnits,
            onChanged: (bool value) {
              settingsProvider.updateShowBaseUnits(value);
            },
          ),
        ),

        const SizedBox(height: 8),
        // Max Combination Size
        const Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: MaxCombinationSizeSetting(),
        ),
        const SizedBox(height: 8),
        // Ad Preferences
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: AdPreferencesTile(
            showAds: settings.showAds,
            onToggleAds: (bool value) {
              settingsProvider.toggleAds(value);
            },
          ),
        ),
        if (settings.showAds)
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.ad_units),
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
          ),
        const SizedBox(height: 8),
        // Additional Settings can be added here
      ],
    );
  }

  Widget? _buildBottomAd(SettingsProvider settingsProvider) {
    if (settingsProvider.settings.showAds &&
        !kIsWeb &&
        Platform.isAndroid &&
        settingsProvider.settings.adPlacements.contains('Bottom Banner')) {
      return Container(
        height: 60,
        color: Colors.transparent,
        child: _adService.bannerAd(),
      );
    }
    return null;
  }
}
