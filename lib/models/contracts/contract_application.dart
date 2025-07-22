// lib/models/contracts/contract_application.dart

import 'package:flutter/foundation.dart';

class ContractApplication {
  final String id;
  final String contractOfferId;
  final String farmerName;
  final String farmerId;
  final String location;
  final String phoneNumber;
  final String email;
  final String farmSize;
  final String experience;
  final String motivation;
  final DateTime appliedAt;
  final String status;
  final String farmLocation;
  final String contactInfo;
  final String notes;

  /// 📌 Constructor
  ContractApplication({
    required this.id,
    required this.contractOfferId,
    required this.farmerName,
    required this.farmerId,
    required this.location,
    required this.phoneNumber,
    required this.email,
    required this.farmSize,
    required this.experience,
    required this.motivation,
    required this.appliedAt,
    this.status = 'Pending',
    this.farmLocation = '',
    this.contactInfo = '',
    this.notes = '',
  });

  /// 🧪 Empty instance for forms or defaults
  factory ContractApplication.empty() {
    return ContractApplication(
      id: '',
      contractOfferId: '',
      farmerName: '',
      farmerId: '',
      location: '',
      phoneNumber: '',
      email: '',
      farmSize: '',
      experience: '',
      motivation: '',
      appliedAt: DateTime.now(),
    );
  }

  /// 📥 JSON Deserialization
  factory ContractApplication.fromJson(Map<String, dynamic> json) {
    return ContractApplication(
      id: json['id'] ?? '',
      contractOfferId: json['contractOfferId'] ?? '',
      farmerName: json['farmerName'] ?? '',
      farmerId: json['farmerId'] ?? '',
      location: json['location'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      farmSize: json['farmSize'] ?? '',
      experience: json['experience'] ?? '',
      motivation: json['motivation'] ?? '',
      appliedAt: DateTime.tryParse(json['appliedAt'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'Pending',
      farmLocation: json['farmLocation'] ?? '',
      contactInfo: json['contactInfo'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  /// 📤 JSON Serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contractOfferId': contractOfferId,
      'farmerName': farmerName,
      'farmerId': farmerId,
      'location': location,
      'phoneNumber': phoneNumber,
      'email': email,
      'farmSize': farmSize,
      'experience': experience,
      'motivation': motivation,
      'appliedAt': appliedAt.toIso8601String(),
      'status': status,
      'farmLocation': farmLocation,
      'contactInfo': contactInfo,
      'notes': notes,
    };
  }

  /// 🧩 copyWith for immutable updates
  ContractApplication copyWith({
    String? id,
    String? contractOfferId,
    String? farmerName,
    String? farmerId,
    String? location,
    String? phoneNumber,
    String? email,
    String? farmSize,
    String? experience,
    String? motivation,
    DateTime? appliedAt,
    String? status,
    String? farmLocation,
    String? contactInfo,
    String? notes,
  }) {
    return ContractApplication(
      id: id ?? this.id,
      contractOfferId: contractOfferId ?? this.contractOfferId,
      farmerName: farmerName ?? this.farmerName,
      farmerId: farmerId ?? this.farmerId,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      farmSize: farmSize ?? this.farmSize,
      experience: experience ?? this.experience,
      motivation: motivation ?? this.motivation,
      appliedAt: appliedAt ?? this.appliedAt,
      status: status ?? this.status,
      farmLocation: farmLocation ?? this.farmLocation,
      contactInfo: contactInfo ?? this.contactInfo,
      notes: notes ?? this.notes,
    );
  }
}
