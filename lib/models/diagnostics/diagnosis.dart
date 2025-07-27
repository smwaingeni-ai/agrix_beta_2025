class Diagnosis {
  final String symptom;
  final String disease;
  final String treatment;
  final String cropOrSpecies;
  final String severity;
  final double likelihood;
  final String imagePath;

  Diagnosis({
    required this.symptom,
    required this.disease,
    required this.treatment,
    required this.cropOrSpecies,
    required this.severity,
    required this.likelihood,
    required this.imagePath,
  });
}
