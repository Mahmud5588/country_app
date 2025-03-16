import 'package:country_app/feauters/country/domain/entities/entites.dart';

abstract class AllCountryRepository {
  Future<List<CountryEntity>> getAllCountry();
}
