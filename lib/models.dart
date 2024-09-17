
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
      mass: this.mass + other.mass,
      length: this.length + other.length,
      time: this.time + other.time,
      electricCurrent: this.electricCurrent + other.electricCurrent,
      temperature: this.temperature + other.temperature,
      amountOfSubstance:
          this.amountOfSubstance + other.amountOfSubstance,
      luminousIntensity:
          this.luminousIntensity + other.luminousIntensity,
    );
  }

  // Divide two dimensions
  Dimension operator /(Dimension other) {
    return Dimension(
      mass: this.mass - other.mass,
      length: this.length - other.length,
      time: this.time - other.time,
      electricCurrent: this.electricCurrent - other.electricCurrent,
      temperature: this.temperature - other.temperature,
      amountOfSubstance:
          this.amountOfSubstance - other.amountOfSubstance,
      luminousIntensity:
          this.luminousIntensity - other.luminousIntensity,
    );
  }

  // Raise a dimension to a power
  Dimension pow(double exponent) {
    return Dimension(
      mass: this.mass * exponent,
      length: this.length * exponent,
      time: this.time * exponent,
      electricCurrent: this.electricCurrent * exponent,
      temperature: this.temperature * exponent,
      amountOfSubstance:
          this.amountOfSubstance * exponent,
      luminousIntensity:
          this.luminousIntensity * exponent,
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
}

class Unit {
  final String name;
  final Dimension dimension;

  Unit({required this.name, required this.dimension});
}

// Define base units with their dimensions
final Map<String, Unit> baseUnits = {
  'kg': Unit(
    name: 'kg',
    dimension: Dimension(mass: 1.0),
  ),
  'g': Unit(
    name: 'g',
    dimension: Dimension(mass: 1.0),
  ),
  'm': Unit(
    name: 'm',
    dimension: Dimension(length: 1.0),
  ),
  'meter': Unit(
    name: 'meter',
    dimension: Dimension(length: 1.0),
  ),
  's': Unit(
    name: 's',
    dimension: Dimension(time: 1.0),
  ),
  'second': Unit(
    name: 'second',
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
  // Add more units as needed
};