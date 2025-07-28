class Diagnosis {
  final String symptom;
  final String disease;
  final String treatment;
  final String? crop;     // for crop-specific
  final String? species;  // for livestock-specific
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

  // Factory from Map (e.g. JSON or CSV row)
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

  // To map (if needed for saving)
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
}
