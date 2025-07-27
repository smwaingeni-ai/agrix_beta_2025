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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Scan this QR to verify or login offline',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
                icon: const Icon(Icons.home),
                label: const Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
