import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simbiotik/Components/TextComponent.dart';
import 'package:simbiotik/Riverpod_Provider/JobsNotifier.dart';
import 'package:simbiotik/Themes/AppTheme.dart';
import 'package:simbiotik/Views/JobDetails.dart';
class DashBoard extends ConsumerWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final jobsState = ref.watch(filteredJobsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.primarycolor,
        title: Textcomponent(text: "HireHub", size: 24, weight: FontWeight.bold),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              // Automatically updates the search query provider as the user types
              onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: 'Search by title or company...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          // 2 & 3. Data Loading & Feed Mapping
          Expanded(
            child: jobsState.when(
              // Loading Tracker Element
              loading: () => const Center(child: CircularProgressIndicator()),

              // Error Layout Context
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppThemes.textcolor, size: 48),
                    const SizedBox(height: 16),
                    Textcomponent(text: error.toString(), textAlign: TextAlign.center,size: 16,weight: FontWeight.w600,),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.read(jobsProvider.notifier).loadJobs(),
                      child: Textcomponent(text: "Try Again", size: 16, weight: FontWeight.bold),
                    )
                  ],
                ),
              ),

              // Successful Feed Layout
              // Successful Feed Layout
              data: (jobs) {
                if (jobs.isEmpty) {
                  return const Center(child: Textcomponent(text: 'No jobs found.',size: 16,weight: FontWeight.bold,));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];

                    // Wrapped with InkWell to capture interactions on the target job item feed context
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // Navigates to the Job Detail Inspector (Screen 2) passing the current job context
                            builder: (context) => JobDetails(job: job),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Textcomponent(text: job.title, size: 16, weight: FontWeight.bold),
                                    const SizedBox(height: 8),
                                    Textcomponent(text: job.company, size: 16, weight: FontWeight.w700),

                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Textcomponent(text: job.location, size: 16, weight: FontWeight.w500),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Interactive Heart Layout Context
                              IconButton(
                                icon: Icon(
                                  job.isBookmarked ? Icons.favorite : Icons.favorite_border,
                                  color: job.isBookmarked ? AppThemes.primarycolor : AppThemes.GreyColor,
                                ),
                                // Call our notifier to safely update the immutable state
                                onPressed: () => ref.read(jobsProvider.notifier).toggleBookmark(job.id),
                                tooltip: job.isBookmarked ? 'Remove Bookmark' : 'Bookmark Job',
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
