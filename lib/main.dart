import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit_converter/pages/settings_page.dart';
import 'package:unit_converter/utils/theme.dart';

import 'pages/home_page.dart';
import 'providers/settings_provider.dart';
import 'services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.initialize();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => SettingsProvider()),
    ], child: const UnitConverterApp()),
  );
}

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          title: 'Unit Converter Pro',
          theme: settingsProvider.settings.isDarkMode ? darkTheme : lightTheme,
          home: const UnitConverterHomePage(),
          routes: {
            SettingsPage.routeName: (context) => SettingsPage(),
          },
        );
      },
    );
  }
}
