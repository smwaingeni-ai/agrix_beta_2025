import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:agrix_beta_2025/screens/core/transaction_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  String? _result;
  String? _timestamp;

  Interpreter? _interpreter;
  List<String> _labels = [];
  final ImagePicker _picker = ImagePicker();
  final IMAGE_SIZE = 224;

  @override
  void initState() {
    super.initState();
    _loadModelAndLabels();
  }

  Future<void> _loadModelAndLabels() async {
    try {
      _interpreter = await Interpreter.fromAsset('tflite/crop_disease_model.tflite');
      final rawLabels = await File('assets/data/crop_labels.txt').readAsLines();
      _labels = rawLabels.map((l) => l.trim()).toList();
      debugPrint('✅ Model and labels loaded');
    } catch (e) {
      debugPrint('❌ Error loading model: $e');
    }
  }

  Future<void> _classifyImage(File image) async {
    final imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(IMAGE_SIZE, IMAGE_SIZE, ResizeMethod.BILINEAR))
        .build();

    final inputImage = FileImage(image);
    final rawImage = await inputImage.obtainKey(const ImageConfiguration());
    final input = TensorImage.fromFile(image);
    final processedImage = imageProcessor.process(input);

    final inputTensor = processedImage.buffer;
    final outputTensor = TensorBuffer.createFixedSize(<int>[1, _labels.length], TfLiteType.float32);
    _interpreter?.run(inputTensor, outputTensor.buffer);

    final confidences = outputTensor.getDoubleList();
    final topIndex = confidences.indexWhere((score) => score == confidences.reduce(max));
    final topLabel = _labels[topIndex];
    final topScore = confidences[topIndex];

    setState(() {
      _result = '🔍 Prediction: $topLabel\n📊 Confidence: ${(topScore * 100).toStringAsFixed(2)}%';
      _timestamp = DateTime.now().toLocal().toIso8601String();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return;

    final file = File(picked.path);
    setState(() => _image = file);
    await _classifyImage(file);
  }

  Future<void> _shareResult() async {
    if (_result == null || _timestamp == null) return;
    final message = '📋 $_result\n🕒 Timestamp: $_timestamp';
    await Share.share(message);
  }

  Future<void> _shareViaWhatsApp() async {
    if (_result == null || _timestamp == null) return;
    final message = '📋 $_result\n🕒 Timestamp: $_timestamp';
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
  void dispose() {
    _interpreter?.close();
    super.dispose();
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
