import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_app/core/route/route_names.dart';
import 'package:country_app/feauters/country/presentation/manager/all_country_provider/all_country_provider.dart';
import 'package:country_app/feauters/country/presentation/manager/all_country_provider/all_country_state.dart';
import 'package:country_app/feauters/country/presentation/pages/country_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class CountryAll extends ConsumerStatefulWidget {
  const CountryAll({super.key});

  @override
  ConsumerState createState() => _CountryAllState();
}

class _CountryAllState extends ConsumerState<CountryAll> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredCountries = [];
  String _query = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(allCountryNotifierProvider.notifier).getCountry();
    });
  }

  void _filterCountries(String query, List<dynamic> countries) {
    setState(() {
      _query = query;
      if (query.isEmpty) {
        _filteredCountries = countries;
      } else {
        _filteredCountries = countries.where((country) {
          final name = country.name.common.toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(allCountryNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Ko'zni charchatmaydigan fon
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Dunyo Mamlakatlari",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.quiz_rounded, color: Colors.deepPurple),
            onPressed: () => Navigator.pushNamed(context, RouteNames.quiz),
          )
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(state),
          Expanded(
            child: _buildBody(state),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AllCountryState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Mamlakat nomini qidiring...",
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (query) {
          if (state is AllCountryLoadedState) {
            _filterCountries(query, state.countries);
          }
        },
      ),
    );
  }

  Widget _buildBody(AllCountryState state) {
    if (state is AllCountryLoadingState) {
      return _buildShimmerList();
    } else if (state is AllCountryLoadedState) {
      final displayList = _query.isEmpty ? state.countries : _filteredCountries;
      
      if (displayList.isEmpty) {
         return Center(child: Text("Ma'lumot topilmadi", style: GoogleFonts.poppins()));
      }

      return ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        itemCount: displayList.length,
        itemBuilder: (context, index) {
          final country = displayList[index];
          return _buildCountryCard(country);
        },
      );
    } else if (state is AllCountryErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
            const SizedBox(height: 10),
            Text(state.message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref.read(allCountryNotifierProvider.notifier).getCountry(),
              child: const Text("Qayta urinish"),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildCountryCard(dynamic country) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CountryDetailPage(countryName: country.name.common),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Hero(
                  tag: country.name.common,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: country.flags.png,
                      width: 80,
                      height: 50,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.flag),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        country.name.common,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        country.capital.isNotEmpty ? country.capital.first : "Poytaxt yo'q",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                       Text(
                        country.region,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }
}
