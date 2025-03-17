import 'package:country_app/feauters/country/domain/entities/entites.dart';

abstract class CountryDetailState {}

class CountryDetailInitialState extends CountryDetailState {}

class CountryDetailLoadingState extends CountryDetailState {}

class CountryDetailLoadedState extends CountryDetailState {
  final CountryEntity country;
  CountryDetailLoadedState(this.country);
}

class CountryDetailErrorState extends CountryDetailState {
  final String message;
  CountryDetailErrorState(this.message);
}
