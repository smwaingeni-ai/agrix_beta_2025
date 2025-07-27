import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPreviewScreen extends StatelessWidget {
  final String userId;
  final String userName;

  const QRPreviewScreen({super.key, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    final qrData = 'AgriX:$userId:$userName';

    return Scaffold(
      appBar: AppBar(title: const Text('🎉 Registration Complete')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Scan this QR to verify your profile or login offline',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 220,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 30),
            Text(
              userName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(
              'User ID: $userId',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.home),
              label: const Text('Go to Dashboard'),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
