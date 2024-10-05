// lib/combination_finder.dart

import 'package:flutter/foundation.dart';
import 'dart:collection';

import 'models.dart';
import 'providers/settings_provider.dart';

class CombinationFinder {
  final List<Unit> availableUnits;
  final Dimension targetDimension;
  final SettingsProvider settingsProvider;
  final HashMap<String, bool> memo = HashMap();

  CombinationFinder({
    required this.availableUnits,
    required this.targetDimension,
    required this.settingsProvider,
  });

  /// Finds all combinations of availableUnits that match the targetDimension.
  List<String> findCombinations() {
    List<String> results = [];

    // Generate combinations from size 1 to maxCombinationSize
    for (int size = 1;
        size <= settingsProvider.settings.maxCombinationSize;
        size++) {
      _findCombinationsRecursive(availableUnits, size, [], results);
    }

    return results;
  }

  void _findCombinationsRecursive(List<Unit> units, int size,
      List<CombinationStep> currentSteps, List<String> results) {
    if (currentSteps.length == size) {
      // Calculate the combined dimension
      Dimension combined = Dimension();
      for (CombinationStep step in currentSteps) {
        Dimension stepDim = step.unit.dimension;
        if (step.operation == Operation.multiply) {
          combined = combined * stepDim;
        } else if (step.operation == Operation.divide) {
          combined = combined / stepDim;
        }
      }

      // Compare with targetDimension
      if (combined == targetDimension) {
        // Create a combination string
        String combination = '';
        for (int i = 0; i < currentSteps.length; i++) {
          CombinationStep step = currentSteps[i];
          if (i > 0) {
            combination += step.operation == Operation.multiply ? ' * ' : ' / ';
          }
          combination += step.unit.name;
        }
        results.add(combination);
      }
      return;
    }

    for (int i = 0; i < units.length; i++) {
      Unit unit = units[i];
      if (kDebugMode){
        print("current steps are $currentSteps");
      }

      // Try different operations without applying exponents
      for (Operation op in Operation.values) {
        List<CombinationStep> newSteps = List.from(currentSteps)
          ..add(CombinationStep(unit: unit, operation: op));
        _findCombinationsRecursive(
            units.sublist(i + 1), size, newSteps, results);
      }
    }
  }
}

enum Operation { multiply, divide }

class CombinationStep {
  final Unit unit;
  final Operation operation;

  CombinationStep({
    required this.unit,
    required this.operation,
  });

  @override
  String toString() {
    return "${unit.name} ${operation.name}";
  }
}
