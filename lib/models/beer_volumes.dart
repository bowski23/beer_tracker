class BeerVolume {
  final String name;
  final double volume;
  final bool isMoreImportant;

  BeerVolume(this.name, this.volume, {this.isMoreImportant = false});
}

final List<BeerVolume> volumes = [
  BeerVolume("", 0.5, isMoreImportant: true),
  BeerVolume("", 0.33, isMoreImportant: true),
  BeerVolume("Maß", 1.0, isMoreImportant: true),
  // BeerVolume("", 0.1),
  // BeerVolume("", 0.125),
  BeerVolume("Kölner Stange", 0.2),
  BeerVolume("Half Pint(US)", 0.227),
  // BeerVolume("", 0.25),
  BeerVolume("Half Pint(UK)", 0.284),
  // BeerVolume("", 0.3),
  // BeerVolume("", 0.4),
  BeerVolume("Pint (US)", 0.473),
  BeerVolume("Pint (UK)", 0.568),
  // BeerVolume("", 0.58),
  // BeerVolume("", 0.75),
  BeerVolume("Yard", 1.13),
  BeerVolume("Pitcher", 1.8),
  BeerVolume("Stiefel", 2.0),
];
