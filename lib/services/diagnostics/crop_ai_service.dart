// lib/services/diagnostics/crop_ai_service.dart

import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:flutter/services.dart';

class CropAIService {
  static const String modelPath = 'tflite/crop_disease_model.tflite';
  static const String labelPath = 'assets/data/crop_labels.txt';
  static const int imageSize = 224;

  late Interpreter _interpreter;
  late List<String> _labels;
  late ImageProcessor _imageProcessor;
  bool _modelLoaded = false;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      final rawLabels = await rootBundle.loadString(labelPath);
      _labels = rawLabels.split('\n').where((e) => e.trim().isNotEmpty).map((e) => e.trim()).toList();
      _imageProcessor = ImageProcessorBuilder()
          .add(ResizeOp(imageSize, imageSize, ResizeMethod.BILINEAR))
          .build();
      _modelLoaded = true;
      debugPrint('✅ Crop model and labels loaded successfully');
    } catch (e) {
      debugPrint('❌ Error loading crop model or labels: $e');
    }
  }

  bool get isModelLoaded => _modelLoaded;

  Future<Map<String, dynamic>> predict(File imageFile) async {
    if (!_modelLoaded) {
      throw Exception('Model not loaded. Call loadModel() first.');
    }

    TensorImage inputImage = TensorImage.fromFile(imageFile);
    inputImage = _imageProcessor.process(inputImage);

    final outputBuffer = TensorBuffer.createFixedSize([1, _labels.length], TfLiteType.float32);
    _interpreter.run(inputImage.buffer, outputBuffer.buffer);

    final confidences = outputBuffer.getDoubleList();
    double maxConfidence = -1;
    int maxIndex = -1;
    for (int i = 0; i < confidences.length; i++) {
      if (confidences[i] > maxConfidence) {
        maxConfidence = confidences[i];
        maxIndex = i;
      }
    }

    final predictedLabel = _labels[maxIndex];
    return {
      'label': predictedLabel,
      'confidence': maxConfidence,
    };
  }

  void close() {
    _interpreter.close();
    _modelLoaded = false;
  }
}
