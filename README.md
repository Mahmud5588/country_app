World Countries & Quiz App 🌍

A feature-rich Flutter application that allows users to explore detailed information about every country in the world and test their geography knowledge with an integrated Quiz mode.

Unlike simple directory apps, this project implements advanced filtering, sorting, and a gamified learning experience, powered by Riverpod for state management and Clean Architecture principles.

🚀 Key Features (Real Implementation)

1. 🔍 Advanced Search & Filtering

The app goes beyond simple name search. Users can filter the country list dynamically by:

Country Name

Capital City

Region (e.g., Asia, Europe)

2. 📊 Sorting Functionality

Users can organize the country list to compare demographics:

Sort by Population: Toggle between Ascending and Descending order to see the most or least populated countries instantly.

3. 🧠 Interactive Quiz Mode

A built-in educational game to test knowledge:

Timed Challenge: 60-second countdown timer.

Capital Guessing: Random questions asking for the capital of a specific country.

Score Tracking: Real-time tracking of Correct vs. Wrong answers.

Results: Summary dialog showing performance after the timer ends.

4. 📄 Detailed Country Insights

Tapping on a country reveals comprehensive data fetched from the API:

Geography: Region, Subregion, Area (km²), and Coordinates.

Demographics: Population and Demonyms.

Politics: UN Membership status, Independence status.

Travel Info: Currency, Timezones, Languages, and Driving Side.

Maps: Direct links to Google Maps and OpenStreetMaps.

5. 🛠 Robust Error Handling

The app handles network states gracefully (as seen in AllCountryRemoteDataSourceImpl):

Connection Timeouts: User-friendly messages for slow networks.

No Internet: Detects socket exceptions and notifies the user.

Server Errors: Handles 404/500 status codes properly.

🏗 Tech Stack & Architecture

This project is built using Clean Architecture to ensure scalability and testability.

Category

Technology

Usage in Code

Language

Dart

Core logic

Framework

Flutter

UI Development

State Management

Riverpod

Used ConsumerStatefulWidget, StateNotifierProvider for reactive UI updates (AllCountryNotifier, CountryDetailNotifier).

Networking

Dio

Advanced HTTP client for fetching data from restcountries.com.

Data Source

REST API

https://restcountries.com/v3.1/all

Architecture

Clean Arch

Separated into Domain (Entities, UseCases), Data (Models, Repositories), and Presentation (Pages, Providers).

UI Components

Material 3

Card, AnimatedOpacity, LinearGradient, ClipRRect for modern aesthetics.

📱 Application Flow

Splash/Home: Loads all countries immediately upon opening (using Future.microtask).

Home Screen (CountryAll):

Displays a list of countries with Flags, Names, Capitals, and Population.

Search Bar: Filters the list in real-time.

Dropdown: Changes the filter type (Name/Capital/Region).

Sort Button: Reorders the list by population.

Floating Action Button: Launches the Quiz Page.

Detail Screen (CountryDetailPage):

Fetches specific country details using countryName.

Displays data with a smooth fade-in animation (AnimatedOpacity).

Includes a "Retry" button if the network request fails.

Quiz Screen (QuizPage):

Randomly selects countries from the loaded list.

Validates user input against the actual capital city.

📂 Project Structure

lib/
├── core/
│   └── route/          # Route names and generators
├── features/
│   └── country/
│       ├── data/       # Data sources, Models, Repositories Implementation
│       ├── domain/     # Entities, Repositories Interfaces, UseCases
│       └── presentation/
│           ├── manager/ # Riverpod Providers & Notifiers
│           └── pages/   # UI Screens (CountryAll, CountryDetail, QuizPage)
└── main.dart           # App Entry point with ProviderScope


📬 Contact

Maxmud Axmedov - Mobile Developer

LinkedIn: linkedin.com/in/maxmud-axmedov

GitHub: github.com/Mahmud5588

Email: axmedovmaxmud839@gmail.com

Developed with ❤️ using Flutter and Riverpod.
