import 'package:country_app/core/route/route_names.dart';
import 'package:country_app/feauters/country/presentation/pages/country_all.dart';
import 'package:country_app/feauters/country/presentation/pages/quiz_page.dart';
import 'package:flutter/material.dart';

class AppRoute {
  BuildContext context;

  AppRoute(this.context);

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.countryAll:
        return MaterialPageRoute(
          builder: (context) => const CountryAll(),
        );
      case RouteNames.quiz:
        return MaterialPageRoute(
          builder: (context) => const QuizPage(),
        );
      default:
        return _errorRoute();
    }
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(
      builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text("Page not found"),
            ),
          ));
}
