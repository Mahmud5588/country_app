import 'package:country_app/feauters/country/presentation/manager/all_country_provider/all_country_provider.dart';
import 'package:country_app/feauters/country/presentation/manager/all_country_provider/all_country_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountryAll extends ConsumerStatefulWidget {
  const CountryAll({super.key});

  @override
  ConsumerState createState() => _CountryAllState();
}

class _CountryAllState extends ConsumerState<CountryAll> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(allCountryNotifierProvider.notifier).getCountry();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(allCountryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Country",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: state is AllCountryLoadingState
          ? const Center(child: CircularProgressIndicator())
          : state is AllCountryLoadedState
              ? ListView.builder(
                  itemCount: state.countries.length,
                  itemBuilder: (context, index) {
                    final country = state.countries[index];
                    return ListTile(
                      leading: Image.network(
                        country.flags.png,
                        width: 100,
                        height: 100,
                      ),
                      title: Text(country.name.common),
                      subtitle: Text(country.capital.toString()),
                      onTap: () {},
                    );
                  },
                )
              : state is AllCountryErrorState
                  ? Center(child: Text(state.message))
                  : const Center(child: Text("No Data")),
    );
  }
}
