enum Flavor {
  dev,
  stg,
  prod;

  static Flavor fromString(String value) {
    return Flavor.values.firstWhere(
      (f) => f.name == value.toLowerCase(),
      orElse: () => Flavor.dev,
    );
  }

  bool get isDev => this == Flavor.dev;
  bool get isStg => this == Flavor.stg;
  bool get isProd => this == Flavor.prod;
}
