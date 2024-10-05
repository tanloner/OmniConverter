
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
      amountOfSubstance:
          amountOfSubstance + other.amountOfSubstance,
      luminousIntensity:
          luminousIntensity + other.luminousIntensity,
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
      amountOfSubstance:
          amountOfSubstance - other.amountOfSubstance,
      luminousIntensity:
          luminousIntensity - other.luminousIntensity,
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
      amountOfSubstance:
          amountOfSubstance * exponent,
      luminousIntensity:
          luminousIntensity * exponent,
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
    name: 'kilogram',
    dimension: Dimension(mass: 1.0),
  ),
  'm': Unit(
    name: 'metre',
    dimension: Dimension(length: 1.0),
  ),
  's': Unit(
    name: 'second',
    dimension: Dimension(time: 1.0),
  ),
  'A': Unit(
    name: 'ampere',
    dimension: Dimension(electricCurrent: 1.0),
  ),
  'K': Unit(
    name: 'kelvin',
    dimension: Dimension(temperature: 1.0),
  ),
  'mol': Unit(
    name: 'mole',
    dimension: Dimension(amountOfSubstance: 1.0),
  ),
  'cd': Unit(
    name: 'candela',
    dimension: Dimension(luminousIntensity: 1.0),
  ),
  'N': Unit(
    name: 'newton',
    dimension: Dimension(mass: 1.0, length: 1.0, time: -2.0),
  ),
  'Pa': Unit(
    name: 'pascal',
    dimension: Dimension(mass: 1.0, length: -1.0, time: -2.0),
  ),
  'J': Unit(
    name: 'joule',
    dimension: Dimension(mass: 1.0, length: 2.0, time: -2.0),
  ),
  'W': Unit(
    name: 'watt',
    dimension: Dimension(mass: 1.0, length: 2.0, time: -3.0),
  ),
  'C': Unit(
    name: 'coulomb',
    dimension: Dimension(electricCurrent: 1.0, time: 1.0),
  ),
  'V': Unit(
    name: 'volt',
    dimension: Dimension(mass: 1.0, length: 2.0, electricCurrent: -1.0, time: -3.0),
  ),
  'F': Unit(
    name: 'farad',
    dimension: Dimension(mass: -1.0, length: -2.0, time: 4.0, electricCurrent: 2.0),
  ),
  'Ω': Unit(
    name: 'ohm',
    dimension: Dimension(mass: 1.0, length: 2.0, electricCurrent: -2.0, time: -3.0),
  ),
  'S': Unit(
    name: 'siemens',
    dimension: Dimension(mass: -1.0, length: -2.0, time: 3.0, electricCurrent: 2.0),
  ),
  'Wb': Unit(
    name: 'weber',
    dimension: Dimension(mass: 1.0, length: 2.0, electricCurrent: -1.0, time: -1.0),
  ),
  'T': Unit(
    name: 'tesla',
    dimension: Dimension(mass: 1.0, electricCurrent: -1.0, time: -2.0),
  ),
  'H': Unit(
    name: 'henry',
    dimension: Dimension(mass: 1.0, length: 2.0, electricCurrent: -2.0, time: -2.0),
  ),
  'lm': Unit(
    name: 'lumen',
    dimension: Dimension(luminousIntensity: 1.0),
  ),
  'lx': Unit(
    name: 'lux',
    dimension: Dimension(luminousIntensity: 1.0, length: -2.0),
  ),
  'Bq': Unit(
    name: 'becquerel',
    dimension: Dimension(time: -1.0),
  ),
  'Gy': Unit(
    name: 'gray',
    dimension: Dimension(length: 2.0, time: -2.0),
  ),
  'Sv': Unit(
    name: 'sievert',
    dimension: Dimension(length: 2.0, time: -2.0),
  ),
  'kat': Unit(
    name: 'katal',
    dimension: Dimension(amountOfSubstance: 1.0, time: -1.0),
  ),
};
