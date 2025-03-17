import 'package:country_app/feauters/country/domain/entities/entites.dart';

abstract class AllCountryRepository {
  Future<List<CountryEntity>> getAllCountry();

  Future<CountryEntity> getCountryDetail({required String countryName});
}
