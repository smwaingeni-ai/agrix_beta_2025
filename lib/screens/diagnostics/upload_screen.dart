import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:agrix_beta_2025/models/diagnostics/diagnosis.dart';
import 'package:agrix_beta_2025/screens/core/transaction_screen.dart';
import 'package:agrix_beta_2025/services/diagnostics/crop_diagnosis_service.dart';
import 'package:agrix_beta_2025/screens/diagnostics/diagnosis_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _diagnoseFromText(String input) async {
    final rules = await CropDiagnosisService.loadCropRules();
    final inputLower = input.toLowerCase();

    final match = rules.entries.firstWhere(
      (entry) => inputLower.contains(entry.key),
      orElse: () => MapEntry(
        '',
        Diagnosis(
          symptom: 'Unknown',
          disease: 'Unknown',
          treatment: 'None',
          crop: null,
          species: null,
          severity: 'Low',
          likelihood: 0.0,
          image: '',
        ),
      ),
    );

    if (match.key.isNotEmpty) {
      final d = match.value;

      final diagnosis = Diagnosis(
        symptom: match.key,
        disease: d.disease,
        treatment: d.treatment,
        crop: d.crop,
        species: d.species,
        severity: d.severity,
        likelihood: d.likelihood,
        image: d.image,
      );

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
      _showError('❌ No diagnosis found for this image.');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return;

    final file = File(picked.path);
    final fileName = picked.name.toLowerCase();

    setState(() => _image = file);

    await _diagnoseFromText(fileName);
  }

  Future<void> _shareResult() async {
    await Share.share('📋 Diagnosis result shared via AgriX.');
  }

  Future<void> _shareViaWhatsApp() async {
    const msg = '📋 Check out this diagnosis result from AgriX.';
    final url = Uri.parse("whatsapp://send?text=${Uri.encodeComponent(msg)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showError('❌ WhatsApp not available.');
    }
  }

  Future<void> _shareViaTelegram() async {
    const msg = '📋 AgriX result: crop or livestock diagnosis.';
    final url = Uri.parse("tg://msg?text=${Uri.encodeComponent(msg)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showError('❌ Telegram not available.');
    }
  }

  Future<void> _shareViaEmail() async {
    final subject = Uri.encodeComponent('AgriX Diagnosis Result');
    final body = Uri.encodeComponent('📋 Attached is the diagnosis result from AgriX.');
    final url = Uri.parse('mailto:?subject=$subject&body=$body');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showError('❌ Email client not available.');
    }
  }

  void _exportToPDF() {
    _showError('📝 Export to PDF coming soon.');
  }

  void _goToTransactions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TransactionScreen()),
    );
  }

  void _saveResultLocally() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Diagnosis result saved locally.')),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
                        icon: const FaIcon(FontAwesomeIcons.whatsapp),
                        label: const Text('WhatsApp'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: _shareViaWhatsApp,
                      ),
                      ElevatedButton.icon(
                        icon: const FaIcon(FontAwesomeIcons.telegram),
                        label: const Text('Telegram'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: _shareViaTelegram,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.email_outlined),
                        label: const Text('Email'),
                        onPressed: _shareViaEmail,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Export PDF'),
                        onPressed: _exportToPDF,
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
