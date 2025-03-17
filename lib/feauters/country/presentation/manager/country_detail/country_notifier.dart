import 'package:country_app/feauters/country/domain/entities/entites.dart';
import 'package:country_app/feauters/country/domain/usecase/country_usecase.dart';
import 'package:country_app/feauters/country/presentation/manager/country_detail/country_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountryDetailNotifier extends StateNotifier<CountryDetailState> {
  final GetCountryDetailUseCase countryDetailUseCase;
  final String countryName;

  CountryDetailNotifier({
    required this.countryDetailUseCase,
    required this.countryName,
  }) : super(CountryDetailInitialState());

  Future<void> getCountryDetail({required String countryName}) async {
    try {
      state = CountryDetailLoadingState();
      final CountryEntity country = await countryDetailUseCase(countryName);
      state = CountryDetailLoadedState(country);
    } catch (e) {
      state = CountryDetailErrorState(e.toString());
    }
  }
}
