import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_app/feauters/country/presentation/manager/all_country_provider/all_country_provider.dart';
import 'package:country_app/feauters/country/presentation/manager/country_detail/country_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CountryDetailPage extends ConsumerStatefulWidget {
  final String countryName;
  const CountryDetailPage({super.key, required this.countryName});

  @override
  ConsumerState createState() => _CountryDetailPageState();
}

class _CountryDetailPageState extends ConsumerState<CountryDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(countryDetailNotifierProvider(widget.countryName).notifier)
          .getCountryDetail(countryName: widget.countryName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(countryDetailNotifierProvider(widget.countryName));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: state is CountryDetailLoadingState
          ? const Center(child: CircularProgressIndicator())
          : state is CountryDetailLoadedState
              ? CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 250.0,
                      floating: false,
                      pinned: true,
                      backgroundColor: Colors.deepPurple,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          widget.countryName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [const Shadow(color: Colors.black45, blurRadius: 10)],
                          ),
                        ),
                        background: Hero(
                          tag: widget.countryName,
                          child: CachedNetworkImage(
                            imageUrl: state.country.flags.png,
                            fit: BoxFit.cover,
                            color: Colors.black.withOpacity(0.3),
                            colorBlendMode: BlendMode.darken,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildInfoSection("Asosiy Ma'lumotlar", [
                              _infoRow(Icons.flag, "Rasmiy nomi", state.country.name.official),
                              _infoRow(Icons.location_city, "Poytaxt", state.country.capital.join(', ')),
                              _infoRow(Icons.public, "Mintaqa", "${state.country.region}, ${state.country.subregion}"),
                            ]),
                            const SizedBox(height: 16),
                            _buildInfoSection("Statistika", [
                              _infoRow(Icons.people, "Aholi", state.country.population.toString()),
                              _infoRow(Icons.landscape, "Maydoni", "${state.country.area} km²"),
                              _infoRow(Icons.access_time, "Vaqt zonasi", state.country.timezones.first),
                            ]),
                            const SizedBox(height: 16),
                            _buildInfoSection("Qo'shimcha", [
                              _infoRow(Icons.monetization_on, "Valyuta", "${state.country.currency.name} (${state.country.currency.symbol})"),
                              _infoRow(Icons.drive_eta, "Harakatlanish", "${state.country.car.side} tomonlama"),
                            ]),
                            const SizedBox(height: 20),
                            if (state.country.maps.googleMaps.isNotEmpty)
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: const Icon(Icons.map),
                                label: const Text("Google Xaritada Ko'rish"),
                                onPressed: () => _launchUrl(state.country.maps.googleMaps),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Center(child: Text("Xatolik yuz berdi", style: GoogleFonts.poppins())),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 10),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          const Divider(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.deepPurpleAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                Text(value, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
