import 'package:country_app/core/route/route_names.dart';
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
  String _selectedFilter = "Name"; // Default filter
  bool _isAscending = true; // Sort order

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
        _filteredCountries = countries.where((country) {
          final name = country.name.common.toLowerCase();
          final capital = country.capital.isNotEmpty
              ? country.capital.first.toLowerCase()
              : "";
          final region = country.region.toLowerCase();

          return (_selectedFilter == "Name" &&
                  name.contains(query.toLowerCase())) ||
              (_selectedFilter == "Capital" &&
                  capital.contains(query.toLowerCase())) ||
              (_selectedFilter == "Region" &&
                  region.contains(query.toLowerCase()));
        }).toList();
      }
    });
  }

  void _sortByPopulation(List<dynamic> countries) {
    setState(() {
      _filteredCountries = List.from(countries);
      _filteredCountries.sort((a, b) {
        return _isAscending
            ? a.population.compareTo(b.population)
            : b.population.compareTo(a.population);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(allCountryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Countries",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("About Country App"),
                  content: const Text(
                    "This app provides detailed information about all countries, "
                    "including their capital, population, and region.\n\n"
                    "Developed by: Your Name",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },
          )
        ],
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
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: "Search...",
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
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: _selectedFilter,
                            items: ["Name", "Capital", "Region"]
                                .map((filter) => DropdownMenuItem(
                                      value: filter,
                                      child: Text(filter),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedFilter = value;
                                  _filterCountries(
                                      _searchController.text, state.countries);
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(_isAscending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward),
                            onPressed: () {
                              setState(() {
                                _isAscending = !_isAscending;
                                _sortByPopulation(state.countries);
                              });
                            },
                          ),
                        ],
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
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      country.capital.isNotEmpty
                                          ? "Capital: ${country.capital.first}"
                                          : "No Capital",
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    Text(
                                      "Population: ${country.population}",
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    Text(
                                      "Region: ${country.region}",
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
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
      floatingActionButton: ElevatedButton(
        style:
            ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
        onPressed: () {
          Navigator.pushNamed(context, RouteNames.quiz);
        },
        child: Text(
          "Start Quiz",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
