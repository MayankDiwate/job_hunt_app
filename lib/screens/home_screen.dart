import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_hunt_app/services/jobs.dart';
import 'package:job_hunt_app/widgets/job_tile.dart';
import 'package:job_hunt_app/widgets/search_widget.dart';

final alertProvider = StateProvider((ref) => false);

class JobScreen extends HookConsumerWidget {
  const JobScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsValue = ref.watch(jobsProvider);
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
            onPressed: () async {
              final res = await showSearch(
                    context: context,
                    delegate: MySearchDelegate(),
                  ) ??
                  "";
              if (res.isNotEmpty) {
                ref.read(queryProvider.notifier).state = res;
              }
            },
            icon: const Icon(Icons.search, size: 30),
          ),
        ],
      ),
      body: jobsValue.when(
        data: (jobs) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            jobs.isEmpty
                ? const Center(child: Text("No Data is fetched !!"))
                : Expanded(
                    child: ListView.builder(
                      itemCount: jobs.length,
                      itemBuilder: (_, i) {
                        final job = jobs[i];
                        return JobTile(job: job);
                      },
                    ),
                  ),
          ],
        ),
        error: (e, st) => Center(child: Text(e.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
