import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class CropAIService {
  static const String _modelPath = 'tflite/crop_disease_model.tflite';
  static const String _labelPath = 'assets/data/crop_labels.txt';
  static const int _imageSize = 224;

  late Interpreter _interpreter;
  late List<String> _labels;
  late ImageProcessor _imageProcessor;
  bool _isLoaded = false;

  /// Initialize model and labels
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(_modelPath);
      final labelData = await rootBundle.loadString(_labelPath);
      _labels = labelData.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      _imageProcessor = ImageProcessorBuilder()
          .add(ResizeOp(_imageSize, _imageSize, ResizeMethod.BILINEAR))
          .build();

      _isLoaded = true;
      print('✅ CropAIService: Model and labels loaded.');
    } catch (e) {
      print('❌ Error loading crop AI model: $e');
      _isLoaded = false;
    }
  }

  /// Predict top label from an image
  Future<Map<String, dynamic>?> classify(File imageFile) async {
    if (!_isLoaded) {
      print('⚠️ CropAIService not initialized.');
      return null;
    }

    try {
      final tensorImage = TensorImage.fromFile(imageFile);
      final processedImage = _imageProcessor.process(tensorImage);

      final input = processedImage.buffer;
      final output = TensorBuffer.createFixedSize([1, _labels.length], TfLiteType.float32);

      _interpreter.run(input, output.buffer);

      final confidences = output.getDoubleList();
      final topIndex = confidences.indexWhere((x) => x == confidences.reduce(max));
      final label = _labels[topIndex];
      final confidence = confidences[topIndex];

      return {
        'label': label,
        'confidence': confidence,
        'scorePercent': (confidence * 100).toStringAsFixed(2),
      };
    } catch (e) {
      print('❌ Classification error: $e');
      return null;
    }
  }

  /// Dispose model when done
  void dispose() {
    _interpreter.close();
    _isLoaded = false;
  }
}
