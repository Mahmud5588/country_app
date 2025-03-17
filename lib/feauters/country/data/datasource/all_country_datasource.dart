import 'package:country_app/feauters/country/data/model/model.dart';
import 'package:dio/dio.dart';

abstract class AllCountryRemoteDataSource {
  Future<List<CountryModel>> getAllCountry();
  Future<CountryModel> getCountryDetail({required String countryName});
}

class AllCountryRemoteDataSourceImpl implements AllCountryRemoteDataSource {
  Dio dio;
  AllCountryRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CountryModel>> getAllCountry() async {
    final response = await dio.get("https://restcountries.com/v3.1/all");

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> jsonList = response.data;
      return jsonList.map((json) => CountryModel.fromJson(json)).toList();
    } else {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<CountryModel> getCountryDetail({required String countryName}) async {
    final response =
        await dio.get("https://restcountries.com/v3.1/name/$countryName");

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> jsonList = response.data;
      return CountryModel.fromJson(jsonList.first);
    } else {
      throw Exception("Something went wrong");
    }
  }
}
