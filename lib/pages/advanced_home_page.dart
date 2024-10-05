import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../combination_finder.dart';
import '../models.dart';
import '../providers/settings_provider.dart';
import '../unit_parser.dart';

class UnitConverterHomePage extends StatefulWidget {
  const UnitConverterHomePage({super.key});

  @override
  _UnitConverterHomePageState createState() => _UnitConverterHomePageState();
}

class _UnitConverterHomePageState extends State<UnitConverterHomePage> {
  final TextEditingController _inputUnitController = TextEditingController();
  final TextEditingController _otherUnitsController = TextEditingController();
  String _result = '';
  bool _isProcessing = false;

  void _processUnits() async {
    setState(() {
      _isProcessing = true;
      _result = '';
    });

    String inputUnitStr = _inputUnitController.text.trim();
    String otherUnitsStr = _otherUnitsController.text.trim();

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
      if (unit == null) {
        setState(() {
          _result =
              'Unknown unit in the list: "$unitStr". Please ensure it is defined.';
          _isProcessing = false;
        });
        return;
      }

      otherUnits.add(unit);
    }

    // Find combinations
    CombinationFinder finder = CombinationFinder(
      availableUnits: otherUnits,
      targetDimension: inputDimension
    );

    List<String> combinations = finder.findCombinations();
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Unit Converter Pro'),
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Input Unit
              TextField(
                controller: _inputUnitController,
                decoration: const InputDecoration(
                  labelText: 'Enter Unit/Formula',
                  hintText: 'e.g., Newton (N) or F = ma',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Other Units
              TextField(
                controller: _otherUnitsController,
                decoration: const InputDecoration(
                  labelText: 'List of Other Units',
                  hintText: 'e.g., kg, m, s, A, K, mol, cd',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              const SizedBox(height: 16),
              // Calculate Button
              ElevatedButton(
                onPressed: _isProcessing ? null : _processUnits,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Full width button
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Calculate'),
              ),
              const SizedBox(height: 16),
            // Output Field
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _result.isEmpty
                        ? 'Your results will appear here.'
                        : _result,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            // Advertisement Placeholder
            //if (settingsProvider.settings.showAds &&
            //settingsProvider.settings.adPlacement == 'Bottom Banner')
            //AdBanner(), // Custom widget for ad banner
          ],
        ),
      ),
      // Conditional Ad Placement
      bottomNavigationBar: settingsProvider.settings.showAds &&
              settingsProvider.settings.adPlacement == 'Bottom Banner'
          ? const SizedBox(
              height: 50,
              //child: AdBanner(),
            )
          : null,
    );
  }
}
