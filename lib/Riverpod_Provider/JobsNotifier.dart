import 'package:riverpod/riverpod.dart';
import 'package:simbiotik/Services/JobServices.dart';
final jobServiceProvider = Provider<JobService>((ref) => JobService());
class JobsNotifier extends StateNotifier<AsyncValue<List<Job>>> {
  final JobService _service;

  JobsNotifier(this._service) : super(const AsyncValue.loading()) {
    loadJobs();
  }

  Future<void> loadJobs() async {
    state = const AsyncValue.loading();
    try {
      final jobs = await _service.fetchJobs();
      state = AsyncValue.data(jobs);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void toggleBookmark(String jobId) {
    if (state is AsyncData<List<Job>>) {
      final currentJobs = state.value!;
      final updatedJobs = currentJobs.map((job) {
        if (job.id == jobId) {
          return job.copyWith(isBookmarked: !job.isBookmarked);
        }
        return job;
      }).toList();

      state = AsyncValue.data(updatedJobs);
    }
  }
}

// The provider exposing the JobsNotifier
final jobsProvider = StateNotifierProvider<JobsNotifier, AsyncValue<List<Job>>>((ref) {
  return JobsNotifier(ref.watch(jobServiceProvider));
});

// Holds the current search query string
final searchQueryProvider = StateProvider<String>((ref) => '');

// Computes the filtered list automatically whenever the search query OR the job list changes
final filteredJobsProvider = Provider<AsyncValue<List<Job>>>((ref) {
  final jobsState = ref.watch(jobsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  return jobsState.whenData((jobs) {
    if (query.isEmpty) return jobs;
    return jobs.where((job) {
      return job.title.toLowerCase().contains(query) ||
          job.company.toLowerCase().contains(query);
    }).toList();
  });
});