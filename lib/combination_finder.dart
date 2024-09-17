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
      List<Unit> current,
      List<String> results) {
    if (current.length == size) {
      // Calculate the combined dimension
      Dimension combined = Dimension();
      for (Unit unit in current) {
        combined = combined * unit.dimension;
      }

      // Compare with targetDimension
      if (combined == targetDimension) {
        // Create a combination string
        String combination =
        current.map((u) => u.name).join(' * ');
        results.add(combination);
      }
      return;
    }

    for (int i = 0; i < units.length; i++) {
      List<Unit> remaining = units.sublist(i + 1);
      _findCombinationsRecursive(
          remaining, size, [...current, units[i]], results);
    }
  }
}
