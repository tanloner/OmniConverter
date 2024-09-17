// lib/main.dart

import 'package:flutter/material.dart';
import 'models.dart';
import 'unit_parser.dart';
import 'combination_finder.dart';

void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UnitConverterHomePage(),
    );
  }
}

class UnitConverterHomePage extends StatefulWidget {
  @override
  _UnitConverterHomePageState createState() =>
      _UnitConverterHomePageState();
}

class _UnitConverterHomePageState
    extends State<UnitConverterHomePage> {
  final TextEditingController _inputUnitController =
  TextEditingController();
  final TextEditingController _otherUnitsController =
  TextEditingController();
  String _result = '';

  void _processUnits() {
    String inputUnitStr = _inputUnitController.text.trim();
    String otherUnitsStr =
    _otherUnitsController.text.trim();

    if (inputUnitStr.isEmpty ||
        otherUnitsStr.isEmpty) {
      setState(() {
        _result =
        'Please enter both input unit and list of other units.';
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
        _result =
        'Please enter at least one valid unit in the list.';
      });
      return;
    }

    // Initialize UnitParser
    UnitParser parser = UnitParser(baseUnits);

    // Parse input unit
    Dimension? inputDimension = parser.parse(inputUnitStr);
    if (inputDimension == null) {
      setState(() {
        _result =
        'Invalid input unit format or unknown units.';
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
        });
        return;
      }

      // Find the unit in baseUnits
      Unit? unit = baseUnits[unitStr];
      if (unit == null) {
        setState(() {
          _result =
          'Unknown unit in the list: "$unitStr". Please ensure it is defined.';
        });
        return;
      }

      otherUnits.add(unit);
    }

    // Find combinations
    CombinationFinder finder = CombinationFinder(
      availableUnits: otherUnits,
      targetDimension: inputDimension,
    );

    List<String> combinations = finder.findCombinations();

    setState(() {
      if (combinations.isNotEmpty) {
        _result =
            'Possible representations:\n' +
                combinations.join('\n');
      } else {
        _result =
        'It is not possible to represent "$inputUnitStr" with the provided units.';
      }
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Unit Converter App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Input Unit
                TextField(
                  controller: _inputUnitController,
                  decoration: InputDecoration(
                    labelText: 'Input Unit (e.g., kg*m/s)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                // Other Units
                TextField(
                  controller: _otherUnitsController,
                  decoration: InputDecoration(
                    labelText:
                    'List of Other Units (comma-separated, e.g., m, s, kg)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                // Process Button
                ElevatedButton(
                  onPressed: _processUnits,
                  child: Text('Process'),
                ),
                SizedBox(height: 16),
                // Result Display
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _result,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}


