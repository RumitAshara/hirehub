class Job {
  static const String defaultUrl = "https://www.arbeitnow.com/api/job-board-api";
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  late final String applyUrl;
  late final bool isBookmarked;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.applyUrl,
    this.isBookmarked = false,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      // The API uses a unique alphanumeric string 'slug' instead of 'id'
      id: json['slug']?.toString() ?? json.hashCode.toString(),
      title: json['title'] ?? 'Unknown Title',
      // Correcting key map from 'company' to 'company_name'
      company: json['company_name'] ?? 'Unknown Company',
      location: json['location'] ?? 'Unknown Location',
      description: json['description'] ?? 'No description provided.',
      // Correcting key map from hardcoded value to target field 'url'
      applyUrl: json['url'] ?? defaultUrl,
      isBookmarked : false,
    );
  }

  Job copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    String? description,
    String? applyUrl,
    bool? isBookmarked,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      description: description ?? this.description,
      applyUrl: applyUrl ?? this.applyUrl,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}