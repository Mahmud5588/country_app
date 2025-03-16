class CountryEntity {
  final NameEntity name;
  final String cca2;
  final bool independent;
  final String status;
  final bool unMember;
  final CurrencyEntity currency;
  final IddEntity idd;
  final List<String> capital;
  final String region;
  final String subregion;
  final Map<String, String> languages;
  final Map<String, TranslationEntity> translations;
  final List<double> latlng;
  final bool landlocked;
  final double area;
  final DemonymsEntity demonyms;
  final String flag;
  final MapEntity maps;
  final int population;
  final CarEntity car;
  final List<String> timezones;
  final List<String> continents;
  final FlagsEntity flags;
  final String startOfWeek;
  final CapitalInfoEntity capitalInfo;

  CountryEntity({
    required this.name,
    required this.cca2,
    required this.independent,
    required this.status,
    required this.unMember,
    required this.currency,
    required this.idd,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.languages,
    required this.translations,
    required this.latlng,
    required this.landlocked,
    required this.area,
    required this.demonyms,
    required this.flag,
    required this.maps,
    required this.population,
    required this.car,
    required this.timezones,
    required this.continents,
    required this.flags,
    required this.startOfWeek,
    required this.capitalInfo,
  });
}

class NameEntity {
  final String common;
  final String official;

  NameEntity({required this.common, required this.official});

  factory NameEntity.fromJson(Map<String, dynamic> json) {
    return NameEntity(
      common: json["common"] ?? "",
      official: json["official"] ?? "",
    );
  }
}

class CurrencyEntity {
  final String name;
  final String symbol;

  CurrencyEntity({required this.name, required this.symbol});

  factory CurrencyEntity.fromJson(Map<String, dynamic> json) {
    var firstCurrency = json.values.isNotEmpty ? json.values.first : {};
    return CurrencyEntity(
      name: firstCurrency["name"] ?? "",
      symbol: firstCurrency["symbol"] ?? "",
    );
  }
}

class IddEntity {
  final String root;
  final List<String> suffixes;

  IddEntity({required this.root, required this.suffixes});

  factory IddEntity.fromJson(Map<String, dynamic> json) {
    return IddEntity(
      root: json["root"] ?? "",
      suffixes: List<String>.from(json["suffixes"] ?? []),
    );
  }
}

class TranslationEntity {
  final String official;
  final String common;

  TranslationEntity({required this.official, required this.common});

  factory TranslationEntity.fromJson(Map<String, dynamic> json) {
    return TranslationEntity(
      official: json["official"] ?? "",
      common: json["common"] ?? "",
    );
  }
}

class DemonymsEntity {
  final String male;
  final String female;

  DemonymsEntity({required this.male, required this.female});

  factory DemonymsEntity.fromJson(Map<String, dynamic> json) {
    final eng =
        json["eng"] as Map<String, dynamic>?; // Null tekshiruv qo‘shamiz
    return DemonymsEntity(
      male: eng?["m"] ?? "", // Null bo‘lsa, bo‘sh string beriladi
      female: eng?["f"] ?? "",
    );
  }
}

class MapEntity {
  final String googleMaps;
  final String openStreetMaps;

  MapEntity({required this.googleMaps, required this.openStreetMaps});

  factory MapEntity.fromJson(Map<String, dynamic> json) {
    return MapEntity(
      googleMaps: json["googleMaps"] ?? "",
      openStreetMaps: json["openStreetMaps"] ?? "",
    );
  }
}

class CarEntity {
  final String side;

  CarEntity({required this.side});

  factory CarEntity.fromJson(Map<String, dynamic> json) {
    return CarEntity(
      side: json["side"] ?? "",
    );
  }
}

class FlagsEntity {
  final String png;
  final String svg;

  FlagsEntity({required this.png, required this.svg});

  factory FlagsEntity.fromJson(Map<String, dynamic> json) {
    return FlagsEntity(
      png: json["png"] ?? "",
      svg: json["svg"] ?? "",
    );
  }
}

class CapitalInfoEntity {
  final List<double> latlng;

  CapitalInfoEntity({required this.latlng});

  factory CapitalInfoEntity.fromJson(Map<String, dynamic> json) {
    return CapitalInfoEntity(
      latlng: List<double>.from(json["latlng"] ?? [0.0, 0.0]),
    );
  }
}
