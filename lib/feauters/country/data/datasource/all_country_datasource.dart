import 'dart:io';

import 'package:country_app/feauters/country/data/model/model.dart';
import 'package:dio/dio.dart';

abstract class AllCountryRemoteDataSource {
  Future<List<CountryModel>> getAllCountry();
  Future<CountryModel> getCountryDetail({required String countryName});
}

class AllCountryRemoteDataSourceImpl implements AllCountryRemoteDataSource {
  final Dio dio;

  AllCountryRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CountryModel>> getAllCountry() async {
    try {
      final response = await dio.get("https://restcountries.com/v3.1/all");

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> jsonList = response.data;
        return jsonList.map((json) => CountryModel.fromJson(json)).toList();
      } else {
        throw ServerException(
            message:
                "Server xatosi: ${response.statusCode} - Ma'lumot olishda muammo yuzaga keldi.");
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: "Noma'lum xatolik: $e");
    }
  }

  @override
  Future<CountryModel> getCountryDetail({required String countryName}) async {
    try {
      final response =
          await dio.get("https://restcountries.com/v3.1/name/$countryName");

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> jsonList = response.data;
        return CountryModel.fromJson(jsonList.first);
      } else {
        throw ServerException(
            message:
                "Server xatosi: ${response.statusCode} - Ma'lumot olishda muammo yuzaga keldi.");
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: "Noma'lum xatolik: $e");
    }
  }

  // DioException’ni boshqarish uchun yordamchi metod
  Exception _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkException(
          message:
              "Internet ulanishi vaqti tugadi. Iltimos, qayta urinib ko‘ring.");
    } else if (e.type == DioExceptionType.connectionError) {
      if (e.error is SocketException) {
        return NetworkException(
            message: "Internet aloqasi yo‘q. Iltimos, ulanishni tekshiring.");
      }
      return NetworkException(
          message: "Tarmoq bilan bog‘liq xatolik yuzaga keldi.");
    } else if (e.type == DioExceptionType.badResponse) {
      return ServerException(
          message:
              "Server xatosi: ${e.response?.statusCode} - ${e.response?.statusMessage}");
    } else {
      return UnknownException(message: "Kutilmagan xatolik: ${e.message}");
    }
  }
}

// Xatoliklar uchun maxsus klasslar
class NetworkException implements Exception {
  final String message;
  NetworkException({required this.message});
}

class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}

class UnknownException implements Exception {
  final String message;
  UnknownException({required this.message});
}
