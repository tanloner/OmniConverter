// lib/models.dart

class Dimension {
  final int mass;
  final int length;
  final int time;
  final int electricCurrent;
  final int temperature;
  final int amountOfSubstance;
  final int luminousIntensity;

  Dimension({
    this.mass = 0,
    this.length = 0,
    this.time = 0,
    this.electricCurrent = 0,
    this.temperature = 0,
    this.amountOfSubstance = 0,
    this.luminousIntensity = 0,
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

  // Check equality of two dimensions
  @override
  bool operator ==(Object other) =>
      other is Dimension &&
          mass == other.mass &&
          length == other.length &&
          time == other.time &&
          electricCurrent == other.electricCurrent &&
          temperature == other.temperature &&
          amountOfSubstance == other.amountOfSubstance &&
          luminousIntensity == other.luminousIntensity;

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
    dimension: Dimension(mass: 1),
  ),
  'g': Unit(
    name: 'g',
    dimension: Dimension(mass: 1),
  ),
  'm': Unit(
    name: 'm',
    dimension: Dimension(length: 1),
  ),
  'meter': Unit(
    name: 'meter',
    dimension: Dimension(length: 1),
  ),
  's': Unit(
    name: 's',
    dimension: Dimension(time: 1),
  ),
  'second': Unit(
    name: 'second',
    dimension: Dimension(time: 1),
  ),
  'A': Unit(
    name: 'A',
    dimension: Dimension(electricCurrent: 1),
  ),
  'K': Unit(
    name: 'K',
    dimension: Dimension(temperature: 1),
  ),
  'mol': Unit(
    name: 'mol',
    dimension: Dimension(amountOfSubstance: 1),
  ),
  'cd': Unit(
    name: 'cd',
    dimension: Dimension(luminousIntensity: 1),
  ),
  'N': Unit(
    name: 'N',
    dimension: Dimension(mass: 1, length: 1, time: -2), // Newton: kg*m/s²
  ),
  'Pa': Unit(
    name: 'Pa',
    dimension: Dimension(mass: 1, length: -1, time: -2), // Pascal: N/m²
  ),
  'J': Unit(
    name: 'J',
    dimension: Dimension(mass: 1, length: 2, time: -2), // Joule: N*m
  ),
  'W': Unit(
    name: 'W',
    dimension: Dimension(mass: 1, length: 2, time: -3), // Watt: J/s
  ),
  // Add more units as needed
};
