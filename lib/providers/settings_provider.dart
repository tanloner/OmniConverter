// lib/providers/settings_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings.dart';

class SettingsProvider with ChangeNotifier {
  Settings _settings = Settings();

  Settings get settings => _settings;

  SettingsProvider() {
    loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _settings = Settings(
      isDarkMode: prefs.getBool('isDarkMode') ?? false,
      showAds: prefs.getBool('showAds') ?? true,
      adPlacement: prefs.getString('adPlacement') ?? 'Bottom Banner',
      maxCombinationSize: prefs.getInt('maxCombinationSize') ?? 5,
    );
    notifyListeners();
  }

  // Update settings and persist them
  Future<void> updateSettings(Settings newSettings) async {
    _settings = newSettings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _settings.isDarkMode);
    await prefs.setBool('showAds', _settings.showAds);
    await prefs.setString('adPlacement', _settings.adPlacement);
    await prefs.setInt('maxCombinationSize', _settings.maxCombinationSize);
    notifyListeners();
  }

  // Toggle Dark Mode
  Future<void> toggleDarkMode(bool isEnabled) async {
    _settings.isDarkMode = isEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _settings.isDarkMode);
    notifyListeners();
  }

  // Toggle Ads
  Future<void> toggleAds(bool isEnabled) async {
    _settings.showAds = isEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showAds', _settings.showAds);
    notifyListeners();
  }

  // Update Ad Placement
  Future<void> updateAdPlacement(String placement) async {
    _settings.adPlacement = placement;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adPlacement', _settings.adPlacement);
    notifyListeners();
  }

  Future<void> updateMaxCombinationSize(int size) async {
    _settings.maxCombinationSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('maxCombinationSize', size);
    notifyListeners();
  }
}
