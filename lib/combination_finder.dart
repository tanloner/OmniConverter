// lib/combination_finder.dart

import 'dart:math';

import 'package:flutter/foundation.dart';

import 'models.dart';
import 'providers/settings_provider.dart';

class CombinationFinder {
  final List<Unit> availableUnits;
  final Dimension targetDimension;
  final SettingsProvider settingsProvider;

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
        size <=
            min(settingsProvider.settings.maxCombinationSize,
                availableUnits.length);
        size++) {
      _findCombinationsRecursive(
        availableUnits, size, [], Dimension(), // Start with a neutral dimension
        results,
      );
    }

    return results;
  }

  void _findCombinationsRecursive(
    List<Unit> units,
    int size,
    List<CombinationStep> currentSteps,
    Dimension combined,
    List<String> results,
  ) {
    if (currentSteps.length == size) {
      if (combined == targetDimension) {
        // Create a combination string
        String combination = '';
        for (int i = 0; i < currentSteps.length; i++) {
          CombinationStep step = currentSteps[i];
          if (i > 0) {
            combination += step.operation == Operation.multiply ? ' * ' : ' / ';
          }
          if (i == 0 && step.operation == Operation.divide) {
            combination += "1/${step.unit.name}";
          } else {
            combination += step.unit.name;
          }
        }
        if (combination == "s * s * s") {
          if (kDebugMode) {
            print("combination: $combination");
            print("current steps: $currentSteps");
            print("combined: $combined");
          }
        }
        results.add(combination);
      }
      return;
    }

    // Compute diffDimension
    Dimension diffDimension = targetDimension / combined;

    // Prune branches
    for (DimensionComponent component in DimensionComponent.values) {
      double diffExponent = diffDimension.getExponent(component);
      if (diffExponent == 0) continue;

      double maxPossibleAdjustment = units.fold(0.0, (sum, unit) {
        double unitExponent = unit.dimension.getExponent(component);
        return sum + unitExponent.abs();
      });

      if (diffExponent.abs() > maxPossibleAdjustment) {
        print("pruned");
        return;
      }
    }

    // Proceed with recursion
    for (int i = 0; i < units.length; i++) {
      Unit unit = units[i];
      print("$unit");
      // Multiply
      Dimension newCombinedMultiply = combined * unit.dimension;
      List<CombinationStep> newStepsMultiply = List.from(currentSteps)
        ..add(CombinationStep(unit: unit, operation: Operation.multiply));
      _findCombinationsRecursive(
        units.sublist(i + 1),
        size,
        newStepsMultiply,
        newCombinedMultiply,
        results,
      );

      // Divide
      Dimension newCombinedDivide = combined / unit.dimension;
      List<CombinationStep> newStepsDivide = List.from(currentSteps)
        ..add(CombinationStep(unit: unit, operation: Operation.divide));
      _findCombinationsRecursive(
        units.sublist(i + 1),
        size,
        newStepsDivide,
        newCombinedDivide,
        results,
      );
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
