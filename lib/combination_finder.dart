// lib/combination_finder.dart

import 'models.dart';

class CombinationFinder {
  final List<Unit> availableUnits;
  final Dimension targetDimension;
  final int maxCombinationSize;

  CombinationFinder({
    required this.availableUnits,
    required this.targetDimension,
    this.maxCombinationSize = 3, // Limit to combinations of 3 units
  });

  /// Finds all combinations of availableUnits that match the targetDimension.
  List<String> findCombinations() {
    List<String> results = [];

    // Generate combinations from size 1 to maxCombinationSize
    for (int size = 1; size <= maxCombinationSize; size++) {
      _findCombinationsRecursive(
          availableUnits, size, [], results);
    }

    return results;
  }

  void _findCombinationsRecursive(
      List<Unit> units,
      int size,
      List<CombinationStep> currentSteps,
      List<String> results) {
    if (currentSteps.length == size) {
      // Calculate the combined dimension
      Dimension combined = Dimension();
      for (CombinationStep step in currentSteps) {
        Dimension stepDim = step.unit.dimension.pow(step.exponent);
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
            combination +=
            step.operation == Operation.multiply ? ' * ' : ' / ';
          }
          combination +=
          step.exponent == 1 ? step.unit.name : '${step.unit.name}^${step.exponent}';
        }
        results.add(combination);
      }
      return;
    }

    for (int i = 0; i < units.length; i++) {
      Unit unit = units[i];

      // Try different operations and exponents
      for (Operation op in Operation.values) {
        for (double exponent in _getPossibleExponents()) {
          List<CombinationStep> newSteps = List.from(currentSteps)
            ..add(CombinationStep(
                unit: unit, operation: op, exponent: exponent));
          _findCombinationsRecursive(
              units.sublist(i + 1), size, newSteps, results);
        }
      }
    }
  }

  /// Defines possible exponents to consider for each unit.
  List<double> _getPossibleExponents() {
    // Define a range of exponents to consider, e.g., -2, -1, 0.5, 1, 2
    return [-2.0, -1.0, 0.5, 1.0, 2.0];
  }
}

enum Operation { multiply, divide }

class CombinationStep {
  final Unit unit;
  final Operation operation;
  final double exponent;

  CombinationStep({
    required this.unit,
    required this.operation,
    required this.exponent,
  });
}
