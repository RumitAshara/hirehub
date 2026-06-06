import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'JobModel.dart';
class JobService {
  Future<List<Job>> fetchJobs() async {
    try {
      final response = await http.get(Uri.parse('https://www.arbeitnow.com/api/job-board-api'));

      if (response.statusCode == 200) {
        // http package requires manual JSON decoding
        Map<String,dynamic> data = json.decode(response.body);
        List<dynamic> jobsList = data['data'];
        return jobsList.map((json) => Job.fromJson(json)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network connection failed: $e');
    }
  }
}
class UrlLauncherService {
  Future<bool> launchExternalUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        return await launchUrl(url, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
final jobServiceProvider = Provider<JobService>((ref) => JobService());
final urlLauncherProvider = Provider<UrlLauncherService>((ref) => UrlLauncherService());
