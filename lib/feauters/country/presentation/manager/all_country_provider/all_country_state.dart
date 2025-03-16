import 'package:country_app/feauters/country/domain/entities/entites.dart';

abstract class AllCountryState {}

class AllCountryInitialState extends AllCountryState {}

class AllCountryLoadingState extends AllCountryState {}

class AllCountryLoadedState extends AllCountryState {
  final List<CountryEntity> countries;
  AllCountryLoadedState(this.countries);
}

class AllCountryErrorState extends AllCountryState {
  final String message;
  AllCountryErrorState(this.message);
}
