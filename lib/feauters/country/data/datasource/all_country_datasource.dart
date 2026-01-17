import 'dart:io';
import 'package:country_app/feauters/country/data/model/model.dart';
import 'package:dio/dio.dart';

abstract class AllCountryRemoteDataSource {
  Future<List<CountryModel>> getAllCountry();
  Future<CountryModel> getCountryDetail({required String countryName});
}

class AllCountryRemoteDataSourceImpl implements AllCountryRemoteDataSource {
  final Dio dio;

  AllCountryRemoteDataSourceImpl({required this.dio}) {
    // Xavfsizlik va tezlik uchun sozlamalar
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.sendTimeout = const Duration(seconds: 10);
  }

  @override
  Future<List<CountryModel>> getAllCountry() async {
    try {
      // API optimizatsiyasi: faqat kerakli maydonlarni so'rash orqali JSON hajmini kamaytirish mumkin edi,
      // lekin hozirgi Model tuzilishi buzilmasligi uchun to'liq so'rov qoldiramiz.
      final response = await dio.get("https://restcountries.com/v3.1/all");

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> jsonList = response.data;
        return jsonList.map((json) => CountryModel.fromJson(json)).toList();
      } else {
        throw ServerException(
            message: "Server xatosi: ${response.statusCode}");
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
      final response = await dio.get("https://restcountries.com/v3.1/name/$countryName");

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> jsonList = response.data;
        if (jsonList.isEmpty) throw ServerException(message: "Ma'lumot topilmadi");
        return CountryModel.fromJson(jsonList.first);
      } else {
        throw ServerException(
            message: "Server xatosi: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: "Noma'lum xatolik: $e");
    }
  }

  Exception _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout || 
        e.type == DioExceptionType.sendTimeout) {
      return NetworkException(
          message: "Internet tezligi past. Iltimos, qayta urinib ko‘ring.");
    } else if (e.type == DioExceptionType.connectionError) {
       return NetworkException(
            message: "Internet aloqasi yo‘q. Iltimos, ulanishni tekshiring.");
    } else if (e.type == DioExceptionType.badResponse) {
      return ServerException(
          message: "Server xatosi: ${e.response?.statusCode}");
    } else {
      return UnknownException(message: "Kutilmagan xatolik yuz berdi");
    }
  }
}

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
