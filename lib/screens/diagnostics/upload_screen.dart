import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:agrix_beta_2025/screens/core/transaction_screen.dart';
import 'package:agrix_beta_2025/services/diagnostics/crop_diagnosis_service.dart';
import 'package:agrix_beta_2025/screens/diagnostics/diagnosis_screen.dart'; // ✅ added

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _diagnoseFromText(String input) async {
    final rules = await CropDiagnosisService.loadCropRules();
    final match = rules.entries.firstWhere(
      (entry) => input.toLowerCase().contains(entry.key),
      orElse: () => MapEntry('', {}),
    );

    if (match.key.isNotEmpty) {
      final diagnosis = {
        'symptom': match.key,
        'disease': match.value['disease'],
        'treatment': match.value['treatment'],
        'crop': match.value['crop'],
        'severity': match.value['severity'],
        'likelihood': match.value['likelihood'],
        'image': match.value['image'],
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DiagnosisScreen(
            diagnosis: diagnosis,
            image: _image,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ No diagnosis found for symptom.')),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return;

    final file = File(picked.path);
    final fileName = picked.name.toLowerCase();

    setState(() => _image = file);

    await _diagnoseFromText(fileName); // E.g., 'wilt.jpg'
  }

  Future<void> _shareResult() async {
    // Optional: Keep for possible future use
    await Share.share('📋 Diagnosis result shared.');
  }

  Future<void> _shareViaWhatsApp() async {
    final message = '📋 See attached diagnosis result.';
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
        builder: (context) => const TransactionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📷 Upload Crop Image'),
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
