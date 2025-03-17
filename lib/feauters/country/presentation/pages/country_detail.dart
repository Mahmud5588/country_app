import 'package:country_app/feauters/country/presentation/manager/all_country_provider/all_country_provider.dart';
import 'package:country_app/feauters/country/presentation/manager/country_detail/country_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class CountryDetailPage extends ConsumerStatefulWidget {
  final String countryName;

  const CountryDetailPage({super.key, required this.countryName});

  @override
  ConsumerState createState() => _CountryDetailPageState();
}

class _CountryDetailPageState extends ConsumerState<CountryDetailPage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(countryDetailNotifierProvider(widget.countryName).notifier)
          .getCountryDetail(countryName: widget.countryName);
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() => _opacity = 1.0);
      });
    });
  }

  void _retryFetch() {
    ref
        .read(countryDetailNotifierProvider(widget.countryName).notifier)
        .getCountryDetail(countryName: widget.countryName);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(countryDetailNotifierProvider(widget.countryName));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.countryName),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: state is CountryDetailLoadingState
            ? const Center(child: CircularProgressIndicator())
            : state is CountryDetailLoadedState
                ? AnimatedOpacity(
                    duration: const Duration(milliseconds: 600),
                    opacity: _opacity,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  state.country.flags.png,
                                  width: 200,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildDetailCard(Icons.flag, "Official Name",
                                state.country.name.official),
                            _buildDetailCard(Icons.location_city, "Capital",
                                state.country.capital.join(', ')),
                            _buildDetailCard(
                                Icons.map, "Region", state.country.region),
                            _buildDetailCard(Icons.terrain, "Subregion",
                                state.country.subregion),
                            _buildDetailCard(Icons.people, "Population",
                                state.country.population.toString()),
                            _buildDetailCard(Icons.landscape, "Area",
                                "${state.country.area} km²"),
                            _buildDetailCard(Icons.access_time, "Timezones",
                                state.country.timezones.join(', ')),
                            _buildDetailCard(Icons.monetization_on, "Currency",
                                "${state.country.currency.name} (${state.country.currency.symbol})"),
                            _buildDetailCard(Icons.language, "Language(s)",
                                state.country.languages.values.join(', ')),
                            _buildDetailCard(Icons.directions_car,
                                "Driving Side", state.country.car.side),
                            _buildDetailCard(Icons.emoji_flags, "Independent",
                                state.country.independent ? "Yes" : "No"),
                            _buildDetailCard(Icons.verified, "UN Member",
                                state.country.unMember ? "Yes" : "No"),
                            if (state.country.maps.googleMaps.isNotEmpty)
                              _buildMapLink("Google Maps",
                                  state.country.maps.googleMaps, Icons.map),
                            if (state.country.maps.openStreetMaps.isNotEmpty)
                              _buildMapLink(
                                  "OpenStreetMaps",
                                  state.country.maps.openStreetMaps,
                                  Icons.location_on),
                          ],
                        ),
                      ),
                    ),
                  )
                : state is CountryDetailErrorState
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _retryFetch,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                              ),
                              child: const Text("Qayta urinish"),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: Text(
                          "No Data",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildMapLink(String title, String url, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.open_in_new, color: Colors.blue),
        onTap: () async {
          final Uri uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Could not open $title")),
            );
          }
        },
      ),
    );
  }
}
