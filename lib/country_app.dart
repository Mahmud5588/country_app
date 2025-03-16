import 'package:country_app/core/route/route_generators.dart';
import 'package:country_app/core/route/route_names.dart';
import 'package:flutter/material.dart';

class CountryApp extends StatelessWidget {
  const CountryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RouteNames.countryAll,
      onGenerateRoute: AppRoute(context).onGenerateRoute,
      debugShowCheckedModeBanner: false,
      title: 'Country App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
