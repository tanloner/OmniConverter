class Settings {
  bool isDarkMode;
  bool showAds;
  String adPlacement;
  int maxCombinationSize;

  Settings({
    this.isDarkMode = false,
    this.showAds = true,
    this.adPlacement = 'Bottom Banner',
    this.maxCombinationSize = 5,
  });

  // Convert Settings to Map for SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'isDarkMode': isDarkMode,
      'showAds': showAds,
      'adPlacement': adPlacement,
      'maxCombinationSize': maxCombinationSize,
    };
  }

  // Create Settings from Map
  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      isDarkMode: map['isDarkMode'] ?? false,
      showAds: map['showAds'] ?? true,
      adPlacement: map['adPlacement'] ?? 'Bottom Banner',
      maxCombinationSize: map['maxCombinationSize'] ?? 5,
    );
  }

  Settings copyWith({
    bool? isDarkMode,
    bool? showAds,
    String? adPlacement,
    int? maxCombinationSize,
  }) {
    return Settings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      showAds: showAds ?? this.showAds,
      adPlacement: adPlacement ?? this.adPlacement,
      maxCombinationSize: maxCombinationSize ?? this.maxCombinationSize,
    );
  }
}
