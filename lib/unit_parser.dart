// lib/unit_parser.dart

import 'models.dart';

class UnitParser {
  final Map<String, Unit> units;

  UnitParser(this.units);

  /// Parses a unit string and returns the corresponding Dimension.
  /// Example: "kg*m/s" -> Dimension(mass:1, length:1, time:-1)
  Dimension? parse(String unitStr) {
    if (unitStr.isEmpty) return null;

    List<String> tokens = _tokenize(unitStr);
    if (tokens.isEmpty) return null;

    Dimension result = Dimension();

    String? operatorSymbol; // '*' or '/'

    for (String token in tokens) {
      if (token == '*' || token == '/') {
        operatorSymbol = token;
        continue;
      }

      // Handle exponent, e.g., m^2
      List<String> parts = token.split('^');
      String unitName = parts[0];
      int exponent = 1;
      if (parts.length == 2) {
        exponent = int.tryParse(parts[1]) ?? 1;
      }

      Unit? unit = units[unitName];
      if (unit == null) {
        return null; // Unknown unit
      }

      Dimension unitDim = unit.dimension;

      // Apply exponent
      unitDim = Dimension(
        mass: unitDim.mass * exponent,
        length: unitDim.length * exponent,
        time: unitDim.time * exponent,
        electricCurrent: unitDim.electricCurrent * exponent,
        temperature: unitDim.temperature * exponent,
        amountOfSubstance:
        unitDim.amountOfSubstance * exponent,
        luminousIntensity:
        unitDim.luminousIntensity * exponent,
      );

      if (operatorSymbol == '/') {
        unitDim = Dimension(
          mass: -unitDim.mass,
          length: -unitDim.length,
          time: -unitDim.time,
          electricCurrent: -unitDim.electricCurrent,
          temperature: -unitDim.temperature,
          amountOfSubstance:
          -unitDim.amountOfSubstance,
          luminousIntensity:
          -unitDim.luminousIntensity,
        );
        operatorSymbol = null;
      } else {
        operatorSymbol = null;
      }

      result = result * unitDim;
    }

    return result;
  }

  /// Tokenizes the unit string into units and operators.
  List<String> _tokenize(String unitStr) {
    List<String> tokens = [];
    String buffer = '';
    for (int i = 0; i < unitStr.length; i++) {
      String char = unitStr[i];
      if (char == '*' || char == '/') {
        if (buffer.isNotEmpty) {
          tokens.add(buffer);
          buffer = '';
        }
        tokens.add(char);
      } else {
        buffer += char;
      }
    }
    if (buffer.isNotEmpty) {
      tokens.add(buffer);
    }
    return tokens;
  }
}
