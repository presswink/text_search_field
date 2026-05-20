import 'package:flutter/material.dart';
import 'package:text_search_field/text_search_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Search Field Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SearchExampleScreen(),
    );
  }
}

class SearchExampleScreen extends StatefulWidget {
  const SearchExampleScreen({super.key});

  @override
  State<SearchExampleScreen> createState() => _SearchExampleScreenState();
}

class _SearchExampleScreenState extends State<SearchExampleScreen> {
  final TextSearchFieldController _countryController = TextSearchFieldController();
  final TextSearchFieldController _cityController = TextSearchFieldController();

  // Mock data
  final List<TextSearchFieldDataModel> _countries = [
    TextSearchFieldDataModel(key: 'in', value: 'India'),
    TextSearchFieldDataModel(key: 'us', value: 'USA'),
    TextSearchFieldDataModel(key: 'ca', value: 'Canada'),
  ];

  final Map<String, List<TextSearchFieldDataModel>> _citiesByCountry = {
    'in': [
      TextSearchFieldDataModel(key: 'del', value: 'Delhi'),
      TextSearchFieldDataModel(key: 'mum', value: 'Mumbai'),
      TextSearchFieldDataModel(key: 'blr', value: 'Bangalore'),
    ],
    'us': [
      TextSearchFieldDataModel(key: 'ny', value: 'New York'),
      TextSearchFieldDataModel(key: 'la', value: 'Los Angeles'),
      TextSearchFieldDataModel(key: 'chi', value: 'Chicago'),
    ],
    'ca': [
      TextSearchFieldDataModel(key: 'tor', value: 'Toronto'),
      TextSearchFieldDataModel(key: 'van', value: 'Vancouver'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Field Example"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Local Search (Select Country)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextSearchField(
              controller: _countryController,
              hint: "Select Country",
              filterItems: _countries,
              onSelected: (index, item) async {
                debugPrint("Selected Country: ${item.value}");
              },
            ),
            const SizedBox(height: 30),
            const Text(
              "Dependent Search (Select City)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              "This field is disabled until a country is selected. It clears automatically if you change the country.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            TextSearchField(
              controller: _cityController,
              dependency: _countryController,
              waitDependency: true,
              hint: "Select City",
              dependencyFetch: (country) async {
                // Simulate a small network delay
                await Future.delayed(const Duration(milliseconds: 500));
                return _citiesByCountry[country.key] ?? [];
              },
              onSelected: (index, item) async {
                debugPrint("Selected City: ${item.value}");
              },
              emptyWidget: const Center(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("No cities found for this country"),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Remote Search with Debouncing",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextSearchField(
              hint: "Search user from server...",
              debounceDuration: const Duration(milliseconds: 500),
              onSearch: (query) async {
                if (query.isEmpty) return [];
                // Simulate an API call
                await Future.delayed(const Duration(seconds: 1));
                return [
                  TextSearchFieldDataModel(key: 'u1', value: 'Result for "$query" (User A)'),
                  TextSearchFieldDataModel(key: 'u2', value: 'Another result for "$query" (User B)'),
                ];
              },
              suggestionPrefixIcon: const Icon(Icons.person_outline, size: 20),
              onSelected: (index, item) async {
                debugPrint("Selected User: ${item.value}");
              },
            ),
            const SizedBox(height: 30),
            const Text(
              "Custom Styled Search",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextSearchField(
              hint: "Search with custom colors",
              fillColor: Colors.blue.withValues(alpha: 0.05),
              suggestionBackgroundColor: Colors.blue[50],
              rippleColor: Colors.blue.withValues(alpha: 0.2),
              suggestionBorderRadius: BorderRadius.circular(20),
              filterItems: [
                TextSearchFieldDataModel(key: '1', value: 'Custom A'),
                TextSearchFieldDataModel(key: '2', value: 'Custom B'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
