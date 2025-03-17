import 'package:country_app/feauters/country/domain/entities/entites.dart';
import 'package:country_app/feauters/country/domain/repository/all_country_repository.dart';

class GetCountryDetailUseCase {
  final AllCountryRepository countryDetailRepository;

  GetCountryDetailUseCase(this.countryDetailRepository);

  Future<CountryEntity> call(String countryName) async {
    return await countryDetailRepository.getCountryDetail(
        countryName: countryName);
  }
}
