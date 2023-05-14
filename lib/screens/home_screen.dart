import 'package:flutter/material.dart';
import 'package:job_hunt_app/services/jobs.dart';
import 'package:job_hunt_app/widgets/job_tile.dart';
import 'package:job_hunt_app/widgets/search_widget.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  Jobs jobsObj = Jobs();
  bool isLoading = true;
  late TextEditingController searchController = TextEditingController();
  final String query = "Flutter Developer";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await jobsObj.getJobs(query: query);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/job1.png", height: 27),
            const Text(
              "HUNT",
              style: TextStyle(
                color: Color(0xff5E17EB),
                fontStyle: FontStyle.italic,
                fontSize: 26,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () =>
                showSearch(context: context, delegate: MySearchDelegate()),
            icon: const Icon(Icons.search, size: 30),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                jobsObj.jobs.isEmpty
                    ? const Center(child: Text("No Data is fetched !!"))
                    : Expanded(
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
                      ),
              ],
            ),
    );
  }
}
