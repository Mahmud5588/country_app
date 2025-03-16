import 'package:country_app/feauters/country/domain/entities/entites.dart';

class CountryModel extends CountryEntity {
  CountryModel({
    required super.name,
    required super.cca2,
    required super.independent,
    required super.status,
    required super.unMember,
    required super.currency,
    required super.idd,
    required super.capital,
    required super.region,
    required super.subregion,
    required super.languages,
    required super.translations,
    required super.latlng,
    required super.landlocked,
    required super.area,
    required super.demonyms,
    required super.flag,
    required super.maps,
    required super.population,
    required super.car,
    required super.timezones,
    required super.continents,
    required super.flags,
    required super.startOfWeek,
    required super.capitalInfo,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: NameEntity.fromJson(json["name"]),
      cca2: json["cca2"] ?? "",
      independent: json["independent"] ?? false,
      status: json["status"] ?? "",
      unMember: json["unMember"] ?? false,
      currency: CurrencyEntity.fromJson(json["currencies"] ?? {}),
      idd: IddEntity.fromJson(json["idd"] ?? {}),
      capital: List<String>.from(json["capital"] ?? []),
      region: json["region"] ?? "",
      subregion: json["subregion"] ?? "",
      languages: (json["languages"] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value.toString()),
          ) ??
          {},
      translations: (json["translations"] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, TranslationEntity.fromJson(value)),
          ) ??
          {},
      latlng: List<double>.from(json["latlng"] ?? [0.0, 0.0]),
      landlocked: json["landlocked"] ?? false,
      area: (json["area"] ?? 0).toDouble(),
      demonyms: DemonymsEntity.fromJson(json["demonyms"] ?? {}),
      flag: json["flag"] ?? "",
      maps: MapEntity.fromJson(json["maps"] ?? {}),
      population: json["population"] ?? 0,
      car: CarEntity.fromJson(json["car"] ?? {}),
      timezones: List<String>.from(json["timezones"] ?? []),
      continents: List<String>.from(json["continents"] ?? []),
      flags: FlagsEntity.fromJson(json["flags"] ?? {}),
      startOfWeek: json["startOfWeek"] ?? "",
      capitalInfo: CapitalInfoEntity.fromJson(json["capitalInfo"] ?? {}),
    );
  }
}
