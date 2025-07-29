// 📁 lib/models/diagnostics/diagnosis.dart

class Diagnosis {
  final String symptom;
  final String disease;
  final String treatment;
  final String? crop;     // 🌾 Crop-specific
  final String? species;  // 🐄 Livestock-specific
  final String severity;
  final double likelihood;
  final String? image;

  Diagnosis({
    required this.symptom,
    required this.disease,
    required this.treatment,
    this.crop,
    this.species,
    required this.severity,
    required this.likelihood,
    this.image,
  });

  /// ✅ Optional helper constructor if you're unsure whether value is crop or species
  factory Diagnosis.fromCropOrSpecies({
    required String symptom,
    required String disease,
    required String treatment,
    required String cropOrSpecies,
    required String severity,
    required double likelihood,
    required String imagePath,
    bool isCrop = true,
  }) {
    return Diagnosis(
      symptom: symptom,
      disease: disease,
      treatment: treatment,
      crop: isCrop ? cropOrSpecies : null,
      species: isCrop ? null : cropOrSpecies,
      severity: severity,
      likelihood: likelihood,
      image: imagePath,
    );
  }

  /// 🔄 Factory from Map (e.g. JSON or CSV row)
  factory Diagnosis.fromMap(Map<String, dynamic> map) {
    return Diagnosis(
      symptom: map['symptom'] ?? '',
      disease: map['disease'] ?? '',
      treatment: map['treatment'] ?? '',
      crop: map['crop'],
      species: map['species'],
      severity: map['severity'] ?? 'Unknown',
      likelihood: double.tryParse(map['likelihood'].toString()) ?? 0.0,
      image: map['image'],
    );
  }

  /// 🔁 Convert to Map for storage or serialization
  Map<String, dynamic> toMap() {
    return {
      'symptom': symptom,
      'disease': disease,
      'treatment': treatment,
      'crop': crop,
      'species': species,
      'severity': severity,
      'likelihood': likelihood.toString(),
      'image': image,
    };
  }

  /// 🧠 Combined field for simplified UI access
  String get cropOrSpecies => crop ?? species ?? 'Unknown';

  /// 🖼️ Fallback-safe image path
  String get imagePath => image ?? '';
}
