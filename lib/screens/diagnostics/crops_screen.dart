import 'package:flutter/material.dart';
import 'upload_screen.dart'; // Assuming this is for image scanning

class CropsScreen extends StatelessWidget {
  const CropsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌾 Crop Diagnosis Options')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.photo),
              label: const Text('Scan Crop Image'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UploadScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.description),
              label: const Text('Describe Manually (Coming Soon)'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Manual entry is not yet implemented')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
