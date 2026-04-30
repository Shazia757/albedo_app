import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class BulkUploadPage extends StatelessWidget {
  const BulkUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bulk Upload Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Easily download sample CSV templates for bulk uploading students, teachers, or mentors.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Template Download Buttons
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Trigger upload logic
                  },
                  icon: const Icon(
                    Icons.download,
                    color: Colors.white,
                  ),
                  label: const Text('Sample CSV - Students'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary, // Deep Purple
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Trigger upload logic
                  },
                  icon: const Icon(
                    Icons.download,
                    color: Colors.white,
                  ),
                  label: const Text('Sample CSV - Teachers'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Deep Purple
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Trigger upload logic
                  },
                  icon: const Icon(
                    Icons.download,
                    color: Colors.white,
                  ),
                  label: const Text('Sample CSV - Mentors'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Deep Purple
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Primary Upload Button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Trigger upload logic
                  },
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Bulk Upload'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF673AB7), // Deep Purple
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateButton(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18, color: color),
        label: Text(label, style: const TextStyle(color: Colors.black87)),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 45),
          alignment: Alignment.centerLeft,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
