enum Location {
  any('Any'),
  albertsons('Albertson\'s'),
  sprouts('Sprouts'),
  target('Target'),
  traderjoes('Trader Joe\'s'),
  costco('Costco'),
  ralphs('Ralphs');

  const Location(this.label);
  final String label;
}
