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
    size <= min(settingsProvider.settings.maxCombinationSize, availableUnits.length);
    size++) {
      _findCombinationsRecursive(
        availableUnits,
        size,
        [],
        Dimension(), // Start with a neutral dimension
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
        // Create a combination string with exponents
        String combination = _buildCombinationString(currentSteps);
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
        if (kDebugMode) {
          print("Pruned due to insufficient adjustment for component: $component");
        }
        return;
      }
    }

    // Proceed with recursion
    for (int i = 0; i < units.length; i++) {
      Unit unit = units[i];
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

  /// Builds a combination string where same units are represented with exponents.
  String _buildCombinationString(List<CombinationStep> steps) {
    // Map to hold unit names and their net exponents
    Map<String, double> unitExponents = {};

    for (CombinationStep step in steps) {
      double exponentChange = step.operation == Operation.multiply ? 1.0 : -1.0;
      unitExponents.update(
        step.unit.name,
            (existing) => existing + exponentChange,
        ifAbsent: () => exponentChange,
      );
    }

    // Separate units with positive and negative exponents
    Map<String, double> positiveExponents = {};
    Map<String, double> negativeExponents = {};

    unitExponents.forEach((unit, exponent) {
      if (exponent > 0) {
        positiveExponents[unit] = exponent;
      } else if (exponent < 0) {
        negativeExponents[unit] = -exponent; // Store as positive for formatting
      }
    });

    // Build numerator and denominator parts
    String numerator = positiveExponents.entries.map((entry) {
      return entry.value == 1.0 ? entry.key : "${entry.key}^${entry.value}";
    }).join(' * ');

    String denominator = negativeExponents.entries.map((entry) {
      return entry.value == 1.0 ? entry.key : "${entry.key}^${entry.value}";
    }).join(' * ');

    if (denominator.isEmpty) {
      return numerator;
    } else if (numerator.isEmpty) {
      // Handle cases like 1 / unit^x
      return "1 / $denominator";
    } else {
      return "$numerator / $denominator";
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
