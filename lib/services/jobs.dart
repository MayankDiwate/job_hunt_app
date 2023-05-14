import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_hunt_app/constants.dart';
// import 'package:job_hunt_app/constants.dart';
import 'package:job_hunt_app/models/job_model.dart';

final dioProvider = Provider(
  (ref) => Dio(
    BaseOptions(
      baseUrl: "https://jsearch.p.rapidapi.com",
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': 'jsearch.p.rapidapi.com',
      },
    ),
  ),
);

final jobsControllerProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return JobsController(dio);
});

final queryProvider = StateProvider((ref) => "Flutter Developer");

final jobsProvider = FutureProvider((ref) {
  final query = ref.watch(queryProvider);
  final jobsController = ref.watch(jobsControllerProvider);
  return jobsController.getJobs(query: query);
});

class JobsController {
  JobsController(this._dio);

  final Dio _dio;

  Future<List<JobModel>> getJobs({String? query}) async {
    Response response = await _dio.get(
      "/search",
      queryParameters: {
        "content-type": "application/json",
        "query": query,
        "page": 1,
        "num_pages": 1
      },
    );

    if (response.data["status"] == "OK") {
      return (response.data["data"] as List)
          .where((e) => e['job_apply_link'] != "" && e["employer_logo"] != null)
          .map((e) => JobModel(
                title: e["job_title"],
                company: e["employer_name"],
                url: e["job_apply_link"],
                imageUrl: e["employer_logo"],
                publisher: e["job_publisher"],
              ))
          .toList();
    }
    return [];
  }
}
