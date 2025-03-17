import 'package:country_app/feauters/country/presentation/manager/all_country_provider/all_country_provider.dart';
import 'package:country_app/feauters/country/presentation/manager/all_country_provider/all_country_state.dart';
import 'package:country_app/feauters/country/presentation/pages/country_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountryAll extends ConsumerStatefulWidget {
  const CountryAll({super.key});

  @override
  ConsumerState createState() => _CountryAllState();
}

class _CountryAllState extends ConsumerState<CountryAll> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredCountries = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(allCountryNotifierProvider.notifier).getCountry();
    });
  }

  void _filterCountries(String query, List<dynamic> countries) {
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = countries;
      } else {
        _filteredCountries = countries
            .where((country) =>
                country.name.common.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(allCountryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Countries",
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
              colors: [Colors.deepPurple, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: state is AllCountryLoadingState
          ? const Center(child: CircularProgressIndicator())
          : state is AllCountryLoadedState
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search for a country...",
                          prefixIcon: const Icon(Icons.search,
                              color: Colors.deepPurple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (query) =>
                            _filterCountries(query, state.countries),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.blueGrey],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: _filteredCountries.isNotEmpty
                              ? _filteredCountries.length
                              : state.countries.length,
                          itemBuilder: (context, index) {
                            final country = _filteredCountries.isNotEmpty
                                ? _filteredCountries[index]
                                : state.countries[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: Hero(
                                  tag: country.flags.png,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      country.flags.png,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  country.name.common,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                subtitle: Text(
                                  country.capital.isNotEmpty
                                      ? country.capital.first
                                      : "No Capital",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    color: Colors.deepPurple),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CountryDetailPage(
                                        countryName: country.name.common,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : state is AllCountryErrorState
                  ? Center(child: Text(state.message))
                  : const Center(child: Text("No Data")),
    );
  }
}
