import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
           backgroundColor: Theme.of(context).colorScheme.surface,

      body: Center(
        child: Card(
          elevation: 8,
          shadowColor: Colors.black26,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            width: 300, // Fixed width to match the "Get Backup" proportions
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Get Backup',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 30),

                // Email Input Field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Backup Action Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logic to send backup to email
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7E3FF2), // Albedo Purple
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Backup',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
