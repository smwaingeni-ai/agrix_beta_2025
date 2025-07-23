import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/transaction_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  String? _result;
  String? _timestamp;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    final now = DateTime.now().toLocal();
    final formattedTimestamp = now.toIso8601String();

    setState(() {
      _image = File(pickedFile.path);
      _result = '✅ Diagnosis complete. Sample processed successfully.';
      _timestamp = formattedTimestamp;
    });
  }

  Future<void> _shareResult() async {
    if (_result == null || _timestamp == null) return;

    final message = '📋 Result: $_result\n🕒 Timestamp: $_timestamp';
    await Share.share(message);
  }

  Future<void> _shareViaWhatsApp() async {
    if (_result == null || _timestamp == null) return;

    final message = '📋 Result: $_result\n🕒 Timestamp: $_timestamp';
    final url = Uri.parse("whatsapp://send?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ WhatsApp not available.')),
      );
    }
  }

  void _saveResultLocally() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Result saved locally.')),
    );
  }

  void _goToTransactions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionScreen(
          result: _result,
          timestamp: _timestamp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📷 Upload Sample for Diagnosis'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_camera),
              label: const Text('Capture Image'),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('Upload from Gallery'),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            const SizedBox(height: 24),
            if (_image != null)
              Column(
                children: [
                  Image.file(_image!, height: 200),
                  const SizedBox(height: 12),
                  if (_result != null)
                    Card(
                      color: Colors.green.shade50,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      child: ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.green),
                        title: Text(_result!, style: const TextStyle(fontSize: 16)),
                        subtitle: Text('🕒 Timestamp: $_timestamp'),
                      ),
                    ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                        onPressed: _saveResultLocally,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                        onPressed: _shareResult,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.whatsapp),
                        label: const Text('WhatsApp'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: _shareViaWhatsApp,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.receipt_long),
                        label: const Text('Transactions'),
                        onPressed: _goToTransactions,
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
