import 'package:country_app/feauters/country/data/datasource/all_country_datasource.dart';
import 'package:country_app/feauters/country/data/repository/all_country_repository_imp.dart';
import 'package:country_app/feauters/country/domain/repository/all_country_repository.dart';
import 'package:country_app/feauters/country/domain/usecase/all_country_usecase.dart';
import 'package:country_app/feauters/country/domain/usecase/country_usecase.dart';
import 'package:country_app/feauters/country/presentation/manager/all_country_provider/all_country_notifier.dart';
import 'package:country_app/feauters/country/presentation/manager/all_country_provider/all_country_state.dart';
import 'package:country_app/feauters/country/presentation/manager/country_detail/country_notifier.dart';
import 'package:country_app/feauters/country/presentation/manager/country_detail/country_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final allCountryRemoteDataSourceProvider =
    Provider<AllCountryRemoteDataSource>((ref) {
  return AllCountryRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final allCountryRepositoryProvider = Provider<AllCountryRepository>((ref) {
  return AllCountryRepositoryImpl(
    ref.watch(allCountryRemoteDataSourceProvider),
    allCountryRemoteDataSource: ref.watch(allCountryRemoteDataSourceProvider),
  );
});

final allCountryUseCaseProvider = Provider<AllCountryUseCase>((ref) {
  return AllCountryUseCase(ref.watch(allCountryRepositoryProvider));
});

final allCountryNotifierProvider =
    StateNotifierProvider<AllCountryNotifier, AllCountryState>((ref) {
  return AllCountryNotifier(
    allCountryUseCase: ref.watch(allCountryUseCaseProvider),
  );
});

// Country Detail uchun providerlar
final countryDetailUseCaseProvider = Provider<GetCountryDetailUseCase>((ref) {
  return GetCountryDetailUseCase(ref.watch(allCountryRepositoryProvider));
});

final countryDetailNotifierProvider = StateNotifierProvider.family<
    CountryDetailNotifier, CountryDetailState, String>((ref, countryName) {
  return CountryDetailNotifier(
    countryDetailUseCase: ref.watch(countryDetailUseCaseProvider),
    countryName: countryName,
  );
});
