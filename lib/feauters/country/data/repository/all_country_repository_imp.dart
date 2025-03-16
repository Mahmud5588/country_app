import 'package:country_app/feauters/country/data/datasource/all_country_datasource.dart';
import 'package:country_app/feauters/country/data/model/model.dart';
import 'package:country_app/feauters/country/domain/repository/all_country_repository.dart';

class AllCountryRepositoryImpl implements AllCountryRepository {
  final AllCountryRemoteDataSource allCountryRemoteDataSource;

  AllCountryRepositoryImpl({required this.allCountryRemoteDataSource});

  @override
  Future<List<CountryModel>> getAllCountry() {
    return allCountryRemoteDataSource.getAllCountry();
  }
}
