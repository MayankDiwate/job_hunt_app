import 'dart:async';

import 'package:flutter/material.dart';
import 'package:job_hunt_app/services/jobs.dart';
import 'package:job_hunt_app/widgets/job_tile.dart';

class MySearchDelegate extends SearchDelegate {
  final StreamController controller = StreamController();
  final Jobs jobsObj = Jobs();
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
            close(context, null);
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
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return jobsObj.jobs.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: jobsObj.jobs.length,
              itemBuilder: (_, i) {
                return JobTile(
                  title: jobsObj.jobs[i].title,
                  publisher: jobsObj.jobs[i].publisher,
                  imageUrl: jobsObj.jobs[i].imageUrl,
                  // "https://d1yjjnpx0p53s8.cloudfront.net/1024px-no_image_available.svg_.png?bjDpkOybMMbgorBhoXnaTzEMDa4.q5m7",
                  company: jobsObj.jobs[i].company,
                  url: jobsObj.jobs[i].url,
                );
              },
            ),
          );
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

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (_, i) {
        return ListTile(
          title: Text(suggestions[i]),
          onTap: () {
            query = suggestions[i];
            showResults(context);
            controller.sink.add(jobsObj.getJobs(query: query));
          },
        );
      },
    );
  }
}
