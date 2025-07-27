import 'package:flutter/material.dart';
import 'upload_screen.dart'; // Crop image scan screen

class CropsScreen extends StatelessWidget {
  const CropsScreen({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🚧 Manual entry feature is coming soon.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        leading: Icon(icon, size: 30, color: Colors.green.shade700),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌾 Crop Diagnosis Options'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildOptionButton(
              context: context,
              icon: Icons.photo_camera,
              label: '📷 Scan Crop Image',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UploadScreen()),
                );
              },
            ),
            _buildOptionButton(
              context: context,
              icon: Icons.edit_note,
              label: '📝 Describe Manually (Coming Soon)',
              onPressed: () => _showComingSoon(context),
            ),
          ],
        ),
      ),
    );
  }
}
