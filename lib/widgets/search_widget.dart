import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate<String> {
  MySearchDelegate();
  final searchResults = [
    "Flutter Developer",
    "React Developer",
    "Java Developer",
    "Python Developer",
    "UI/UX Designer",
    "Product Manager",
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, "");
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ""),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where(
      (searchResult) {
        final resuts = searchResult.toLowerCase();
        final input = query.toLowerCase();

        return resuts.contains(input);
      },
    ).toList();

    if (suggestions.isEmpty) suggestions.add(query);

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (_, i) {
        return ListTile(
          title: Text(suggestions[i]),
          onTap: () {
            close(context, suggestions[i]);
          },
        );
      },
    );
  }
}
