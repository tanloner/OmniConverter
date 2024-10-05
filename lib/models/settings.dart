class Settings {
  bool isDarkMode;
  bool showAds;
  List<String> adPlacements;
  int maxCombinationSize;

  Settings({
    this.isDarkMode = true,
    this.showAds = true,
    this.adPlacements = const ['Bottom Banner'],
    this.maxCombinationSize = 5,
  });

  // Convert Settings to Map for SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'isDarkMode': isDarkMode,
      'showAds': showAds,
      'adPlacements': adPlacements,
      'maxCombinationSize': maxCombinationSize,
    };
  }

  // Create Settings from Map
  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      isDarkMode: map['isDarkMode'] ?? true,
      showAds: map['showAds'] ?? true,
      adPlacements: map['adPlacement'] ?? ['Bottom Banner'],
      maxCombinationSize: map['maxCombinationSize'] ?? 5,
    );
  }

  Settings copyWith({
    bool? isDarkMode,
    bool? showAds,
    List<String>? adPlacements,
    int? maxCombinationSize,
  }) {
    return Settings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      showAds: showAds ?? this.showAds,
      adPlacements: adPlacements ?? this.adPlacements,
      maxCombinationSize: maxCombinationSize ?? this.maxCombinationSize,
    );
  }
}
