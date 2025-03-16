import 'package:country_app/feauters/country/domain/entities/entites.dart';
import 'package:country_app/feauters/country/domain/usecase/all_country_usecase.dart';
import 'package:country_app/feauters/country/presentation/manager/all_country_provider/all_country_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllCountryNotifier extends StateNotifier<AllCountryState> {
  final AllCountryUseCase allCountryUseCase;

  AllCountryNotifier({required this.allCountryUseCase})
      : super(AllCountryInitialState());

  Future<void> getCountry() async {
    try {
      state = AllCountryLoadingState();
      final List<CountryEntity> countries =
          await allCountryUseCase.getAllCountry();
      state = AllCountryLoadedState(countries);
    } catch (e) {
      state = AllCountryErrorState(e.toString());
    }
  }
}
