import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simbiotik/Components/TextComponent.dart';
import 'package:simbiotik/Services/JobServices.dart';
import 'package:simbiotik/Themes/AppTheme.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetails extends ConsumerWidget {
  final Job job;

  const JobDetails({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.primarycolor,
        title: Textcomponent(text: "Job Details", size: 24, weight: FontWeight.bold),
        elevation: 0,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              // minimumSize: const Size.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: AppThemes.secondarycolor,
              foregroundColor: Colors.white,
            ),
            child: const Textcomponent(
              text: 'Apply Now',weight: FontWeight.bold,size: 16,),
            ),
          ),
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Textcomponent(
              text : job.title,
              weight: FontWeight.bold,
              size: 16,
            ),
            const SizedBox(height: 8),
            Textcomponent(
              text : job.company,
              weight: FontWeight.bold,
              size: 16,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Textcomponent(
                  text : job.location,
                  weight: FontWeight.bold,
                  size: 16,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(),
            ),
            const SizedBox(height: 24),
            const Textcomponent(
              text : "Apply",
              weight: FontWeight.bold,
              size: 16,
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: ()async{
                final launcher = ref.read(urlLauncherProvider);
                final success = await launcher.launchExternalUrl(job.applyUrl);
                if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open the link.')),
                  );
                }
              },
              child: Textcomponent(
                text : job.applyUrl,
                weight: FontWeight.bold,
                size: 16,
              ),
            ),
            const SizedBox(height: 24),

            const Textcomponent(
              text : "Description",
              weight: FontWeight.bold,
              size: 16,
            ),
            const SizedBox(height: 24),
            Textcomponent(
              text : job.description,
              weight: FontWeight.bold,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}