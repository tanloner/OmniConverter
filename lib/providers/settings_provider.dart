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
      isDarkMode: prefs.getBool('isDarkMode') ?? true,
      showAds: prefs.getBool('showAds') ?? true,
      adPlacements: prefs.getStringList('adPlacements') ?? ['Bottom Banner'],
      maxCombinationSize: prefs.getInt('maxCombinationSize') ?? 5,
      showBaseUnits: prefs.getBool('showBaseUnits') ?? false,
    );
    notifyListeners();
  }

  // Update settings and persist them
  Future<void> updateSettings(Settings newSettings) async {
    _settings = newSettings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _settings.isDarkMode);
    await prefs.setBool('showAds', _settings.showAds);
    await prefs.setStringList('adPlacements', _settings.adPlacements);
    await prefs.setInt('maxCombinationSize', _settings.maxCombinationSize);
    await prefs.setBool('showBaseUnits', _settings.showBaseUnits);
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
  Future<void> updateAdPlacements(List<String> placements) async {
    _settings.adPlacements = placements;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('adPlacements', _settings.adPlacements);
    notifyListeners();
  }

  Future<void> updateMaxCombinationSize(int size) async {
    _settings.maxCombinationSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('maxCombinationSize', size);
    notifyListeners();
  }

  Future<void> updateShowBaseUnits(bool isEnabled) async{
    _settings.showBaseUnits = isEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showBaseUnits', isEnabled);
    notifyListeners();
  }
}
