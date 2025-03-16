import 'package:country_app/feauters/country/domain/entities/entites.dart';
import 'package:country_app/feauters/country/domain/repository/all_country_repository.dart';

class AllCountryUseCase {
  final AllCountryRepository allCountryRepository;

  AllCountryUseCase(this.allCountryRepository);

  Future<List<CountryEntity>> getAllCountry() async {
    return await allCountryRepository.getAllCountry();
  }
}
