class JobModel {
  String title;
  String company;
  String url;
  String imageUrl;
  String publisher;

  JobModel({
    required this.title,
    required this.company,
    required this.url,
    required this.imageUrl,
    required this.publisher,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      title: json["job_title"],
      company: json["employer_name"],
      url: json["job_apply_link"],
      imageUrl: json["employer_logo"],
      publisher: json["job_publisher"],
    );
  }
}
