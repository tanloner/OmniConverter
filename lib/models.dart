// lib/models.dart

class Dimension {
  final double mass;
  final double length;
  final double time;
  final double electricCurrent;
  final double temperature;
  final double amountOfSubstance;
  final double luminousIntensity;

  Dimension({
    this.mass = 0.0,
    this.length = 0.0,
    this.time = 0.0,
    this.electricCurrent = 0.0,
    this.temperature = 0.0,
    this.amountOfSubstance = 0.0,
    this.luminousIntensity = 0.0,
  });

  // Multiply two dimensions
  Dimension operator *(Dimension other) {
    return Dimension(
      mass: mass + other.mass,
      length: length + other.length,
      time: time + other.time,
      electricCurrent: electricCurrent + other.electricCurrent,
      temperature: temperature + other.temperature,
      amountOfSubstance: amountOfSubstance + other.amountOfSubstance,
      luminousIntensity: luminousIntensity + other.luminousIntensity,
    );
  }

  // Divide two dimensions
  Dimension operator /(Dimension other) {
    return Dimension(
      mass: mass - other.mass,
      length: length - other.length,
      time: time - other.time,
      electricCurrent: electricCurrent - other.electricCurrent,
      temperature: temperature - other.temperature,
      amountOfSubstance: amountOfSubstance - other.amountOfSubstance,
      luminousIntensity: luminousIntensity - other.luminousIntensity,
    );
  }

  // Raise a dimension to a power
  Dimension pow(double exponent) {
    return Dimension(
      mass: mass * exponent,
      length: length * exponent,
      time: time * exponent,
      electricCurrent: electricCurrent * exponent,
      temperature: temperature * exponent,
      amountOfSubstance: amountOfSubstance * exponent,
      luminousIntensity: luminousIntensity * exponent,
    );
  }

  // Check equality of two dimensions (with a tolerance for floating-point precision)
  @override
  bool operator ==(Object other) {
    if (other is! Dimension) return false;
    const double tolerance = 1e-9;
    return (mass - other.mass).abs() < tolerance &&
        (length - other.length).abs() < tolerance &&
        (time - other.time).abs() < tolerance &&
        (electricCurrent - other.electricCurrent).abs() < tolerance &&
        (temperature - other.temperature).abs() < tolerance &&
        (amountOfSubstance - other.amountOfSubstance).abs() < tolerance &&
        (luminousIntensity - other.luminousIntensity).abs() < tolerance;
  }

  double getExponent(DimensionComponent component) {
    switch (component) {
      case DimensionComponent.mass:
        return mass;
      case DimensionComponent.length:
        return length;
      case DimensionComponent.time:
        return time;
      case DimensionComponent.electricCurrent:
        return electricCurrent;
      case DimensionComponent.temperature:
        return temperature;
      case DimensionComponent.amountOfSubstance:
        return amountOfSubstance;
      case DimensionComponent.luminousIntensity:
        return luminousIntensity;
    }
  }


  @override
  int get hashCode =>
      mass.hashCode ^
      length.hashCode ^
      time.hashCode ^
      electricCurrent.hashCode ^
      temperature.hashCode ^
      amountOfSubstance.hashCode ^
      luminousIntensity.hashCode;

  @override
  String toString() {
    return 'M:$mass L:$length T:$time I:$electricCurrent Th:$temperature N:$amountOfSubstance J:$luminousIntensity';
  }

  double abs() {
    return (mass.abs() + length.abs() + time.abs() + electricCurrent.abs() + temperature.abs() + amountOfSubstance.abs() + luminousIntensity.abs());
  }

  double sum(){
    return (mass + length + time + electricCurrent + temperature + amountOfSubstance + luminousIntensity);
  }

  String toFormulaString() {
    const double tolerance = 1e-9;
    final components = [
      Unit(name: 'kg', dimension: Dimension(mass: mass)),
      Unit(name: 'm', dimension: Dimension(length: length)),
      Unit(name: 's', dimension: Dimension(time: time)),
      Unit(name: 'A', dimension: Dimension(electricCurrent: electricCurrent)),
      Unit(name: 'K', dimension: Dimension(temperature: temperature)),
      Unit(name: 'mol', dimension: Dimension(amountOfSubstance: amountOfSubstance)),
      Unit(name: 'cd', dimension: Dimension(luminousIntensity: luminousIntensity)),
    ];

    List<String> numeratorTerms = [];
    List<String> denominatorTerms = [];

    for (var component in components) {
      if (component.dimension.abs() < tolerance) continue;
      if (component.dimension.sum() > 0) {
        numeratorTerms.add(_formatTerm(component.name, component.dimension.sum()));
      } else {
        final positiveExponent = -component.dimension.sum();
        denominatorTerms.add(_formatTerm(component.name, positiveExponent));
      }
    }

    String numerator = numeratorTerms.join(' * ');
    String denominator = denominatorTerms.join(' * ');

    if (numerator.isEmpty && denominator.isEmpty) {
      return '1';
    } else if (denominator.isEmpty) {
      return numerator.isNotEmpty ? numerator : '1';
    } else if (numerator.isEmpty) {
      return '1 / $denominator';
    } else {
      return '$numerator / $denominator';
    }
  }

  String _formatTerm(String symbol, double exponent) {
    String exponentStr = _formatExponent(exponent);
    return exponent == 1 ? symbol : '$symbol^$exponentStr';
  }

  String _formatExponent(double value) {
    const epsilon = 1e-9;
    final roundedValue = value.roundToDouble();
    if ((value - roundedValue).abs() < epsilon) {
      return '${roundedValue.toInt()}';
    } else {
      String str = value.toString();
      if (str.endsWith('.0')) {
        return str.substring(0, str.length - 2);
      }
      return str;
    }
  }
}

class Unit {
  final String name;
  final Dimension dimension;

  Unit({required this.name, required this.dimension});

  @override
  String toString() {
    return "${super.toString()}\nName: $name\nDimensions: ${dimension.toString()}\n";
  }
}

// Enum for dimension components
enum DimensionComponent {
  mass,
  length,
  time,
  electricCurrent,
  temperature,
  amountOfSubstance,
  luminousIntensity,
}

//TODO Add the actual names of units, and their symbols for future features
// Define base units with their dimensions
final Map<String, Unit> baseUnits = {
  'kg': Unit(
    name: 'kg',
    dimension: Dimension(mass: 1.0),
  ),
  'm': Unit(
    name: 'm',
    dimension: Dimension(length: 1.0),
  ),
  's': Unit(
    name: 's',
    dimension: Dimension(time: 1.0),
  ),
  'A': Unit(
    name: 'A',
    dimension: Dimension(electricCurrent: 1.0),
  ),
  'K': Unit(
    name: 'K',
    dimension: Dimension(temperature: 1.0),
  ),
  'mol': Unit(
    name: 'mol',
    dimension: Dimension(amountOfSubstance: 1.0),
  ),
  'cd': Unit(
    name: 'cd',
    dimension: Dimension(luminousIntensity: 1.0),
  ),
  'N': Unit(
    name: 'N',
    dimension: Dimension(mass: 1.0, length: 1.0, time: -2.0),
  ),
  'Pa': Unit(
    name: 'Pa',
    dimension: Dimension(mass: 1.0, length: -1.0, time: -2.0),
  ),
  'J': Unit(
    name: 'J',
    dimension: Dimension(mass: 1.0, length: 2.0, time: -2.0),
  ),
  'W': Unit(
    name: 'W',
    dimension: Dimension(mass: 1.0, length: 2.0, time: -3.0),
  ),
  'C': Unit(
    name: 'C',
    dimension: Dimension(electricCurrent: 1.0, time: 1.0),
  ),
  'V': Unit(
    name: 'V',
    dimension:
        Dimension(mass: 1.0, length: 2.0, electricCurrent: -1.0, time: -3.0),
  ),
  'F': Unit(
    name: 'F',
    dimension:
        Dimension(mass: -1.0, length: -2.0, time: 4.0, electricCurrent: 2.0),
  ),
  'ohm': Unit( //TODO: Ω is not seen as alphanumeric. Problem in lexer (unit_parser.dart)
    name: 'ohm',
    dimension:
        Dimension(mass: 1.0, length: 2.0, electricCurrent: -2.0, time: -3.0),
  ),
  'S': Unit(
    name: 'S',
    dimension:
        Dimension(mass: -1.0, length: -2.0, time: 3.0, electricCurrent: 2.0),
  ),
  'Wb': Unit(
    name: 'Wb',
    dimension:
        Dimension(mass: 1.0, length: 2.0, electricCurrent: -1.0, time: -1.0),
  ),
  'T': Unit(
    name: 'T',
    dimension: Dimension(mass: 1.0, electricCurrent: -1.0, time: -2.0),
  ),
  'H': Unit(
    name: 'H',
    dimension:
        Dimension(mass: 1.0, length: 2.0, electricCurrent: -2.0, time: -2.0),
  ),
  'lm': Unit(
    name: 'lm',
    dimension: Dimension(luminousIntensity: 1.0),
  ),
  'lx': Unit(
    name: 'lx',
    dimension: Dimension(luminousIntensity: 1.0, length: -2.0),
  ),
  'Bq': Unit(
    name: 'Bq',
    dimension: Dimension(time: -1.0),
  ),
  'Gy': Unit(
    name: 'Gy',
    dimension: Dimension(length: 2.0, time: -2.0),
  ),
  'Sv': Unit(
    name: 'Sv',
    dimension: Dimension(length: 2.0, time: -2.0),
  ),
  'kat': Unit(
    name: 'kat',
    dimension: Dimension(amountOfSubstance: 1.0, time: -1.0),
  ),
};
