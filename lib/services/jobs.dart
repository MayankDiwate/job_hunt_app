import 'package:dio/dio.dart';
import 'package:job_hunt_app/constants.dart';
// import 'package:job_hunt_app/constants.dart';
import 'package:job_hunt_app/models/job_model.dart';

class Jobs {
  void main() async {
    const String apiUrl = 'https://jsearch.p.rapidapi.com/search';
    const String apiKey = '1980b48c9fmshad18de077371fc5p11c066jsna61900f446f0';

    final dio = Dio();
    dio.options.headers['x-rapidapi-key'] = apiKey;

    final List<JobModel> jobs = [];

    try {
      final response = await dio.get(apiUrl);
      final List<dynamic> jobList = response.data['jobs'];
      for (final jobData in jobList) {
        final job = JobModel.fromJson(jobData);
        jobs.add(job);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<JobModel> jobs = [];

  Future<void> getJobs({String? query}) async {
    String url = 'https://jsearch.p.rapidapi.com/search';

    Response response = await Dio().get(url,
        queryParameters: {
          "content-type": "application/json",
          "query": query,
          "page": 1,
          "num_pages": 1
        },
        options: Options(headers: {
          'X-RapidAPI-Key': API_KEY,
          'X-RapidAPI-Host': 'jsearch.p.rapidapi.com',
        }));

    print(response.data);

    if (response.data["status"] == "OK") {
      response.data["data"].forEach(
        (job) {
          if (job['job_apply_link'] != "" && job["employer_logo"] != null) {
            JobModel jobModel = JobModel(
              title: job["job_title"],
              company: job["employer_name"],
              url: job["job_apply_link"],
              imageUrl: job["employer_logo"],
              publisher: job["job_publisher"],
            );
            jobs.add(jobModel);
          }
        },
      );
    }
  }
}
