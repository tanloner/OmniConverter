// lib/pages/unit_converter_home_page.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit_converter/services/ad_service.dart';

import '../combination_finder.dart';
import '../models.dart';
import '../providers/settings_provider.dart';
import '../unit_parser.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/result_display.dart';

class UnitConverterHomePage extends StatefulWidget {
  const UnitConverterHomePage({super.key});

  @override
  UnitConverterHomePageState createState() => UnitConverterHomePageState();
}

class UnitConverterHomePageState extends State<UnitConverterHomePage> {
  final TextEditingController _inputUnitController = TextEditingController();
  final TextEditingController _otherUnitsController = TextEditingController();
  String _result = '';
  bool _isProcessing = false;
  final AdService _adService = AdService();

  void _processUnits() async {
    setState(() {
      _isProcessing = true;
      _result = '';
    });

    String inputUnitStr = _inputUnitController.text.trim();
    String otherUnitsStr = _otherUnitsController.text.trim();
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    if (inputUnitStr.isEmpty || otherUnitsStr.isEmpty) {
      setState(() {
        _result = 'Please enter both input unit and list of other units.';
        _isProcessing = false;
      });
      return;
    }

    // Parse other units
    List<String> otherUnitsList = otherUnitsStr
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (otherUnitsList.isEmpty) {
      setState(() {
        _result = 'Please enter at least one valid unit in the list.';
        _isProcessing = false;
      });
      return;
    }

    // Initialize UnitParser
    UnitParser parser = UnitParser(baseUnits);

    // Parse input unit
    Dimension? inputDimension = parser.parse(inputUnitStr);
    if (inputDimension == null) {
      setState(() {
        _result = 'Invalid input unit format or unknown units.';
        _isProcessing = false;
      });
      return;
    }

    // Parse other units
    List<Unit> otherUnits = [];
    for (String unitStr in otherUnitsList) {
      Dimension? dim = parser.parse(unitStr);
      if (dim == null) {
        setState(() {
          _result =
              'Invalid unit in the list: "$unitStr". Please check the unit names.';
          _isProcessing = false;
        });
        return;
      }

      // Find the unit in baseUnits
      Unit? unit = baseUnits[unitStr];
      unit ??= Unit(name: unitStr, dimension: dim);
      otherUnits.add(unit);
    }
    CombinationFinder finder = CombinationFinder(
      availableUnits: otherUnits,
      targetDimension: inputDimension,
      settingsProvider: settingsProvider,
    );

    List<String> combinations = finder.findCombinations();
    if (kDebugMode) {
      print("Combinations are: $combinations");
    }
    combinations = combinations.toSet().toList();

    setState(() {
      if (combinations.isNotEmpty) {
        _result = 'Possible representations:\n${combinations.join('\n')}';
      } else {
        _result =
            'It is not possible to represent "$inputUnitStr" with the provided units.';
      }
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _inputUnitController.dispose();
    _otherUnitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Text('OmniConverter'),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            // Web/Desktop Layout
            return Center(
              child: Container(
                width: 800,
                padding: const EdgeInsets.all(16.0),
                child: _buildContent(context, settingsProvider),
              ),
            );
          } else {
            // Mobile Layout
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildContent(context, settingsProvider),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: _buildBottomAd(settingsProvider),
    );
  }

  Widget _buildContent(BuildContext context, SettingsProvider settingsProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Ad Placement
        if (settingsProvider.settings.showAds &&
            settingsProvider.settings.adPlacements.contains("Top Banner") &&
            !kIsWeb &&
            Platform.isAndroid)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            alignment: Alignment.center,
            child: _adService.bannerAd(),
          ),
        const SizedBox(height: 16),
          Column(
              children: [
                // Input Unit
                CustomTextField(
                  controller: _inputUnitController,
                  labelText: 'Enter Unit/Formula',
                  hintText: 'e.g., Newton (N) or F = ma',
                  icon: Icons.calculate,
                ),
                const SizedBox(height: 16),
                // Other Units
                CustomTextField(
                  controller: _otherUnitsController,
                  labelText: 'List of Other Units',
                  hintText: 'e.g., kg, m, s, A, K, mol, cd',
                  icon: Icons.list,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                const SizedBox(height: 24),
                // Calculate Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _processUnits,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: settingsProvider.settings.isDarkMode
                          ? Colors.deepPurple
                          : Colors.blueAccent,
                      disabledBackgroundColor:
                      settingsProvider.settings.isDarkMode
                          ? Colors.grey[700]
                          : Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: _isProcessing
                        ? const CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : const Text(
                      'Calculate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        const SizedBox(height: 16),
        // Result Display
        ResultDisplay(result: _result),
      ],
    );
  }

  Widget? _buildBottomAd(SettingsProvider settingsProvider) {
    if (settingsProvider.settings.showAds &&
        settingsProvider.settings.adPlacements.contains('Bottom Banner') &&
        !kIsWeb &&
        Platform.isAndroid) {
      return Container(
        height: 60,
        padding: const EdgeInsets.all(8.0),
        child: _adService.bannerAd(),
      );
    }
    return null;
  }
}
